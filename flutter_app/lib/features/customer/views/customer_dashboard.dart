import 'package:flutter/material.dart';
import 'create_delivery_view.dart';
import 'delivery_history_view.dart';
import '../../shared/footer_widget.dart';

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customer Dashboard')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const DeliveryHistoryView()),
                      );
                    },
                    icon: const Icon(Icons.history),
                    label: const Text('My Deliveries'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
                  ),
                ],
              ),
            ),
          ),
          const FooterWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New Delivery'),
        icon: const Icon(Icons.add_location_alt),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateDeliveryView()),
          );
        },
      ),
    );
  }
}
