import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/socket_service.dart';
import 'dart:async';

class DriverTrackingView extends ConsumerStatefulWidget {
  final String deliveryId;
  const DriverTrackingView({required this.deliveryId, Key? key}) : super(key: key);

  @override
  ConsumerState<DriverTrackingView> createState() => _DriverTrackingViewState();
}

class _DriverTrackingViewState extends ConsumerState<DriverTrackingView> {
  GoogleMapController? _mapController;
  List<LatLng> polylinePoints = [];
  LatLng? currentLocation;
  Timer? locationTimer;

  @override
  void initState() {
    super.initState();
    socketService.connect('TOKEN'); // TODO: Use real token from auth state
    socketService.joinDelivery(widget.deliveryId);
    socketService.onLocation((data) {
      setState(() {
        currentLocation = LatLng(data['lat'], data['lng']);
        polylinePoints.add(currentLocation!);
      });
    });
    loadPolyline();
    // For demo/location test: simulate update every 7 seconds
    locationTimer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (currentLocation != null) {
        socketService.sendLocation(widget.deliveryId, currentLocation!.longitude + 0.0002, currentLocation!.latitude + 0.0002);
      }
    });
  }

  Future<void> loadPolyline() async {
    try {
      final res = await apiService.get('/tracking/live/${widget.deliveryId}');
      setState(() {
        polylinePoints = List<Map<String, dynamic>>.from(res.data)
          .map((pt) => LatLng(pt['lat'], pt['lng'])).toList();
        if (polylinePoints.isNotEmpty) currentLocation = polylinePoints.last;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    locationTimer?.cancel();
    socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Trip Tracking')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: currentLocation ?? LatLng(6.5244,3.3792), zoom: 13),
        onMapCreated: (c) => _mapController = c,
        markers: currentLocation != null
            ? {Marker(markerId: const MarkerId('me'), position: currentLocation!)}
            : {},
        polylines: {
          if (polylinePoints.length > 1)
            Polyline(
              polylineId: PolylineId('route'),
              color: Colors.blue,
              width: 4,
              points: polylinePoints,
            ),
        },
      ),
    );
  }
}

