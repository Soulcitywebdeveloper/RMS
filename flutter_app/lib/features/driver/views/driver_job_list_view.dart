import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/driver_jobs_viewmodel.dart';
import 'driver_tracking_view.dart';

class DriverJobListView extends ConsumerWidget {
  const DriverJobListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsState = ref.watch(driverJobsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Available Jobs')),
      body: jobsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobsState.hasError
              ? Center(child: Text(jobsState.error.toString()))
              : jobsState.value!.isEmpty
                  ? const Center(child: Text('No jobs found'))
                  : ListView.builder(
                      itemCount: jobsState.value!.length,
                      itemBuilder: (ctx, i) {
                        final job = jobsState.value![i];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: Icon(Icons.local_shipping),
                            title: Text('Pickup: ${job['pickupLocation'] ?? ''}'),
                            subtitle: Text('Dropoff: ${job['dropoffLocation'] ?? ''} - Weight: ${job['itemWeight']} kg'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (job['status'] == 'REQUESTED')
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
                                    onPressed: () => ref.read(driverJobsProvider.notifier).acceptJob(job['_id']),
                                  ),
                                if (job['status'] == 'ACCEPTED')
                                  IconButton(
                                    icon: const Icon(Icons.play_arrow, color: Colors.blue),
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => DriverTrackingView(deliveryId: job['_id']),
                                      ),
                                    ),
                                  ),
                                if (job['status'] == 'IN_TRANSIT')
                                  IconButton(
                                    icon: const Icon(Icons.flag, color: Colors.orange),
                                    onPressed: () => ref.read(driverJobsProvider.notifier).completeTrip(job['_id']),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
