import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';

final driverJobsProvider = StateNotifierProvider<DriverJobsViewModel, AsyncValue<List<Map<String, dynamic>>>>((ref) => DriverJobsViewModel());

class DriverJobsViewModel extends StateNotifier<AsyncValue<List<Map<String, dynamic>>>> {
  DriverJobsViewModel() : super(const AsyncValue.loading()) {
    loadJobs();
  }

  Future<void> loadJobs() async {
    state = const AsyncValue.loading();
    try {
      final res = await apiService.get('/deliveries?assigned=true'); // Or custom backend API
      state = AsyncValue.data(List<Map<String, dynamic>>.from(res.data));
    } catch (_) {
      state = AsyncValue.error('Failed to load jobs');
    }
  }

  Future<void> acceptJob(String deliveryId) async {
    try {
      await apiService.put('/deliveries/$deliveryId/status', data: {'status':'ACCEPTED'});
      await loadJobs();
    } catch (e) {}
  }

  Future<void> startTrip(String deliveryId) async {
    try {
      await apiService.put('/deliveries/$deliveryId/status', data: {'status':'IN_TRANSIT'});
      await loadJobs();
    } catch (e) {}
  }

  Future<void> completeTrip(String deliveryId) async {
    try {
      await apiService.put('/deliveries/$deliveryId/status', data: {'status':'DELIVERED'});
      await loadJobs();
    } catch (e) {}
  }
}

