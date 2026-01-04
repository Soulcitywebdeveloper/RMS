import 'package:flutter/material.dart';
import 'driver_job_list_view.dart';
import '../../shared/footer_widget.dart';

class DriverDashboard extends StatelessWidget {
  const DriverDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Driver Dashboard')),
      body: Column(
        children: [
          const Expanded(
            child: Center(child: Text('Welcome, Driver!')),
          ),
          const FooterWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('View Jobs'),
        icon: const Icon(Icons.local_shipping),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const DriverJobListView()),
          );
        },
      ),
    );
  }
}
