import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/delivery_history_viewmodel.dart';
import 'customer_tracking_view.dart';

class DeliveryHistoryView extends ConsumerWidget {
  const DeliveryHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveriesState = ref.watch(deliveryHistoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('My Deliveries')),
      body: deliveriesState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : deliveriesState.hasError
              ? Center(child: Text(deliveriesState.error.toString()))
              : deliveriesState.value!.isEmpty
                  ? const Center(child: Text('No deliveries yet'))
                  : ListView.builder(
                      itemCount: deliveriesState.value!.length,
                      itemBuilder: (ctx, i) {
                        final delivery = deliveriesState.value![i];
                        return Card(
                          margin: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: Icon(Icons.local_shipping),
                            title: Text('Item: ${delivery['itemType'] ?? 'N/A'}'),
                            subtitle: Text('Status: ${delivery['status'] ?? 'N/A'} - Weight: ${delivery['itemWeight']} kg'),
                            trailing: IconButton(
                              icon: const Icon(Icons.track_changes),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => CustomerTrackingView(deliveryId: delivery['_id']),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

