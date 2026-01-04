import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';

final deliveryHistoryProvider = StateNotifierProvider<DeliveryHistoryViewModel, AsyncValue<List<Map<String, dynamic>>>>((ref) => DeliveryHistoryViewModel());

class DeliveryHistoryViewModel extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  DeliveryHistoryViewModel() : super(const AsyncValue.loading()) {
    loadDeliveries();
  }

  Future<void> loadDeliveries() async {
    state = const AsyncValue.loading();
    try {
      final res = await apiService.get('/deliveries?customer=true'); // Backend should filter by logged-in customer
      state = AsyncValue.data(List<Map<String, dynamic>>.from(res.data));
    } catch (_) {
      state = AsyncValue.error('Failed to load deliveries');
    }
  }
}

