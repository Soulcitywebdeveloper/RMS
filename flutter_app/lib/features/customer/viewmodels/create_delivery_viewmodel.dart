import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/services/api_service.dart';

final createDeliveryProvider = StateNotifierProvider<CreateDeliveryViewModel, AsyncValue<bool?>>((ref) => CreateDeliveryViewModel());

class CreateDeliveryViewModel extends StateNotifier<AsyncValue<bool?>> {
  CreateDeliveryViewModel() : super(const AsyncValue.data(null));

  double calculatePrice(double weight, String vehicle, String urgency) {
    // Simple price estimate (tweak for your needs)
    double base = 1000; // NGN
    if (vehicle == 'BIKE') base = 1000;
    if (vehicle == 'CAR') base = 2000;
    if (vehicle == 'VAN') base = 3500;
    if (vehicle == 'TRUCK' || vehicle == 'CONTAINER') base = 5000;
    base += weight * 50;
    if (urgency == 'URGENT') base *= 1.3;
    return base;
  }

  Future<void> submitDelivery(LatLng pickup, LatLng dropoff, String itemType, double itemWeight, String vehicle, String urgency, double price) async {
    state = const AsyncValue.loading();
    try {
      await apiService.post('/deliveries', data: {
        'pickupLocation': {'coordinates': [pickup.longitude, pickup.latitude]},
        'dropoffLocation': {'coordinates': [dropoff.longitude, dropoff.latitude]},
        'itemType': itemType,
        'itemWeight': itemWeight,
        'vehicleType': vehicle,
        'urgency': urgency,
        'price': price,
      });
      state = const AsyncValue.data(true);
    } catch (e) {
      state = AsyncValue.error('Failed to create delivery');
    }
  }
}

