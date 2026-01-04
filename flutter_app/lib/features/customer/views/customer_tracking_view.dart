import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/socket_service.dart';
import 'dart:async';

class CustomerTrackingView extends ConsumerStatefulWidget {
  final String deliveryId;
  const CustomerTrackingView({required this.deliveryId, Key? key}) : super(key: key);

  @override
  ConsumerState<CustomerTrackingView> createState() => _CustomerTrackingViewState();
}

class _CustomerTrackingViewState extends ConsumerState<CustomerTrackingView> {
  GoogleMapController? _mapController;
  List<LatLng> polylinePoints = [];
  LatLng? driverLocation;
  String deliveryStatus = 'REQUESTED';
  Timer? updateTimer;

  @override
  void initState() {
    super.initState();
    socketService.connect('TOKEN'); // TODO: Use real token from auth
    socketService.joinDelivery(widget.deliveryId);
    socketService.onLocation((data) {
      setState(() {
        driverLocation = LatLng(data['lat'], data['lng']);
        if (!polylinePoints.contains(driverLocation)) {
          polylinePoints.add(driverLocation!);
        }
      });
    });
    loadDeliveryData();
    updateTimer = Timer.periodic(const Duration(seconds: 5), (_) => loadDeliveryData());
  }

  Future<void> loadDeliveryData() async {
    try {
      final res = await apiService.get('/deliveries/${widget.deliveryId}');
      setState(() {
        deliveryStatus = res.data['status'] ?? 'REQUESTED';
        if (res.data['pickupLocation'] != null) {
          final coords = res.data['pickupLocation']['coordinates'];
          polylinePoints.insert(0, LatLng(coords[1], coords[0]));
        }
        if (res.data['dropoffLocation'] != null) {
          final coords = res.data['dropoffLocation']['coordinates'];
          polylinePoints.add(LatLng(coords[1], coords[0]));
        }
      });
      final trackRes = await apiService.get('/tracking/live/${widget.deliveryId}');
      setState(() {
        polylinePoints = List<Map<String, dynamic>>.from(trackRes.data)
          .map((pt) => LatLng(pt['lat'], pt['lng'])).toList();
        if (polylinePoints.isNotEmpty) driverLocation = polylinePoints.last;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    updateTimer?.cancel();
    socketService.disconnect();
    super.dispose();
  }

  String getStatusText(String status) {
    switch (status) {
      case 'REQUESTED': return 'Waiting for driver';
      case 'ACCEPTED': return 'Driver accepted';
      case 'PICKED_UP': return 'Picked up';
      case 'IN_TRANSIT': return 'In transit';
      case 'DELIVERED': return 'Delivered';
      default: return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Delivery')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                Icon(Icons.local_shipping, color: Colors.blue),
                const SizedBox(width: 8),
                Text('Status: ${getStatusText(deliveryStatus)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: driverLocation ?? LatLng(6.5244, 3.3792),
                zoom: 13,
              ),
              onMapCreated: (c) => _mapController = c,
              markers: {
                if (driverLocation != null)
                  Marker(
                    markerId: const MarkerId('driver'),
                    position: driverLocation!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                  ),
                if (polylinePoints.isNotEmpty)
                  Marker(
                    markerId: const MarkerId('pickup'),
                    position: polylinePoints.first,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                  ),
                if (polylinePoints.length > 1)
                  Marker(
                    markerId: const MarkerId('dropoff'),
                    position: polylinePoints.last,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                  ),
              },
              polylines: {
                if (polylinePoints.length > 1)
                  Polyline(
                    polylineId: const PolylineId('route'),
                    color: Colors.blue,
                    width: 4,
                    points: polylinePoints,
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

