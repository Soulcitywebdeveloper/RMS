import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/loading_widget.dart';
import '../../../shared/reusable_button.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../../customer/views/customer_dashboard.dart';
import '../../driver/views/driver_dashboard.dart';
import '../../company/views/company_dashboard.dart';

class OtpView extends ConsumerWidget {
  final String phone;
  final String role;
  OtpView({required this.phone, required this.role, Key? key}) : super(key: key);
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('OTP sent to $phone'),
            const SizedBox(height: 24),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(labelText: 'OTP'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            if (authState.isLoading)
              const LoadingWidget()
            else
              ReusableButton(
                text: 'Verify',
                onPressed: () async {
                  await ref.read(authProvider.notifier).login(phone, _otpController.text);
                  final val = ref.read(authProvider);
                  if (!val.hasError && val.value != null) {
                    final userRole = val.value!['role'];
                    Widget dashboard;
                    if (userRole == 'CUSTOMER') {
                      dashboard = const CustomerDashboard();
                    } else if (userRole == 'DRIVER') {
                      dashboard = const DriverDashboard();
                    } else if (userRole == 'LOGISTICS_COMPANY') {
                      dashboard = const CompanyDashboard();
                    } else {
                      dashboard = const Scaffold(body: Center(child: Text('Unknown Role')));
                    }
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => dashboard), 
                      (route) => false,
                    );
                  }
                },
              ),
            if (authState.hasError)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(authState.error.toString(), style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
