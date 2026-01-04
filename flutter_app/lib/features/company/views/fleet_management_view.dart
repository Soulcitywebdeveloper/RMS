import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/company_fleet_viewmodel.dart';

class FleetManagementView extends ConsumerWidget {
  const FleetManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fleetState = ref.watch(companyFleetProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Fleet Management')),
      body: fleetState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : fleetState.hasError
              ? Center(child: Text(fleetState.error.toString()))
              : ListView.builder(
                  itemCount: fleetState.value!['vehicles']?.length ?? 0,
                  itemBuilder: (ctx, i) {
                    final vehicle = fleetState.value!['vehicles'][i];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Icon(Icons.directions_car),
                        title: Text('${vehicle['type']} - ${vehicle['plateNumber']}'),
                        subtitle: Text('Capacity: ${vehicle['capacityKg']} kg'),
                        trailing: Text(vehicle['isAvailable'] ? 'Available' : 'Busy'),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddVehicleDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddVehicleDialog(BuildContext context, WidgetRef ref) {
    final typeController = TextEditingController();
    final plateController = TextEditingController();
    final capacityController = TextEditingController();
    String selectedType = 'BIKE';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Vehicle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedType,
              items: ['BIKE','MOTORCYCLE','CAR','VAN','BUS','TRUCK','CONTAINER']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => selectedType = v!,
            ),
            TextField(controller: plateController, decoration: const InputDecoration(labelText: 'Plate Number')),
            TextField(controller: capacityController, decoration: const InputDecoration(labelText: 'Capacity (kg)'), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(companyFleetProvider.notifier).addVehicle(
                selectedType,
                plateController.text,
                double.tryParse(capacityController.text) ?? 0,
              );
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

