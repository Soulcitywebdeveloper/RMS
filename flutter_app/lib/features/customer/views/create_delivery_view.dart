import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/reusable_button.dart';
import '../viewmodels/create_delivery_viewmodel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateDeliveryView extends ConsumerStatefulWidget {
  const CreateDeliveryView({Key? key}) : super(key: key);
  @override
  ConsumerState<CreateDeliveryView> createState() => _CreateDeliveryViewState();
}

class _CreateDeliveryViewState extends ConsumerState<CreateDeliveryView> {
  final pickupController = TextEditingController();
  final dropoffController = TextEditingController();
  LatLng? pickupLatLng;
  LatLng? dropoffLatLng;
  final itemTypeController = TextEditingController();
  final weightController = TextEditingController();
  String vehicleType = 'BIKE';
  String urgency = 'NORMAL';
  double? estimatedPrice;

  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createDeliveryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Create Delivery')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 180,
              child: GoogleMap(
                onMapCreated: (c) => mapController = c,
                initialCameraPosition: CameraPosition(target: LatLng(6.5244, 3.3792), zoom: 10),
                markers: {
                  if (pickupLatLng != null) Marker(markerId: MarkerId('pickup'), position: pickupLatLng!),
                  if (dropoffLatLng != null) Marker(markerId: MarkerId('dropoff'), position: dropoffLatLng!),
                },
                onTap: (LatLng pos) async {
                  if (pickupLatLng == null) {
                    setState(() { pickupLatLng = pos; });
                  } else if (dropoffLatLng == null) {
                    setState(() { dropoffLatLng = pos; });
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            Text(pickupLatLng != null ? 'Pickup: ${pickupLatLng!.latitude}, ${pickupLatLng!.longitude}' : 'Tap map for Pickup location'),
            Text(dropoffLatLng != null ? 'Drop-off: ${dropoffLatLng!.latitude}, ${dropoffLatLng!.longitude}' : 'Tap map for Drop-off location'),
            const SizedBox(height: 10),
            TextField(
              controller: itemTypeController,
              decoration: const InputDecoration(labelText: 'Item Type'),
            ),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField<String>(
              value: vehicleType,
              items: ['BIKE','MOTORCYCLE','CAR','VAN','BUS','TRUCK','CONTAINER']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => vehicleType = v!),
              decoration: const InputDecoration(labelText: 'Vehicle Type'),
            ),
            DropdownButtonFormField<String>(
              value: urgency,
              items: ['NORMAL','URGENT']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => urgency = v!),
              decoration: const InputDecoration(labelText: 'Urgency'),
            ),
            const SizedBox(height: 10),
            if (estimatedPrice != null)
               Text('Estimated Price: ₦${estimatedPrice!.toStringAsFixed(2)}', style: TextStyle(color: Colors.green)),
            const SizedBox(height: 16),
            ReusableButton(
              text: state.isLoading ? 'Submitting...' : 'Submit',
              onPressed: state.isLoading ? null : () async {
                if (pickupLatLng == null || dropoffLatLng == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select pickup and drop-off on map')));
                  return;
                }
                final price = ref.read(createDeliveryProvider.notifier).calculatePrice(
                  double.tryParse(weightController.text) ?? 0,
                  vehicleType, urgency,
                );
                setState(() => estimatedPrice = price);
                await ref.read(createDeliveryProvider.notifier).submitDelivery(
                  pickupLatLng!, dropoffLatLng!, itemTypeController.text,
                  double.tryParse(weightController.text) ?? 0, vehicleType, urgency, price
                );
                if (!state.hasError && state.value == true) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delivery created!')));
                  Navigator.pop(context);
                }
              },
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(state.error.toString(), style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}

