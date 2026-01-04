import 'package:flutter/material.dart';
import 'fleet_management_view.dart';
import '../../shared/footer_widget.dart';

class CompanyDashboard extends StatelessWidget {
  const CompanyDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Logistics Company Dashboard')),
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
                        MaterialPageRoute(builder: (_) => const FleetManagementView()),
                      );
                    },
                    icon: const Icon(Icons.directions_car),
                    label: const Text('Manage Fleet'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
                  ),
                ],
              ),
            ),
          ),
          const FooterWidget(),
        ],
      ),
    );
  }
}
