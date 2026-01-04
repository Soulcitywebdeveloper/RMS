import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';

final companyFleetProvider = StateNotifierProvider<CompanyFleetViewModel, AsyncValue<Map<String, dynamic>>>((ref) => CompanyFleetViewModel());

class CompanyFleetViewModel extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  CompanyFleetViewModel() : super(const AsyncValue.loading()) {
    loadFleet();
  }

  Future<void> loadFleet() async {
    state = const AsyncValue.loading();
    try {
      final vehiclesRes = await apiService.get('/vehicles');
      state = AsyncValue.data({
        'vehicles': List<Map<String, dynamic>>.from(vehiclesRes.data),
      });
    } catch (_) {
      state = AsyncValue.error('Failed to load fleet');
    }
  }

  Future<void> addVehicle(String type, String plateNumber, double capacityKg) async {
    try {
      await apiService.post('/vehicles', data: {
        'type': type,
        'plateNumber': plateNumber,
        'capacityKg': capacityKg,
      });
      await loadFleet();
    } catch (e) {}
  }
}

