import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/reusable_button.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'otp_view.dart';

class PhoneLoginView extends StatefulWidget {
  final String role;
  const PhoneLoginView({required this.role, Key? key}) : super(key: key);

  @override
  State<PhoneLoginView> createState() => _PhoneLoginViewState();
}

class _PhoneLoginViewState extends State<PhoneLoginView> {
  final phoneController = TextEditingController();
  bool sendingOtp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login (${widget.role})')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            ReusableButton(
              text: sendingOtp ? 'Sending OTP...' : 'Send OTP',
              onPressed: sendingOtp
                  ? null
                  : () async {
                      setState(() => sendingOtp = true);
                      // API call to send OTP; for now, always success
                      await Future.delayed(const Duration(seconds: 1));
                      setState(() => sendingOtp = false);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OtpView(
                            phone: phoneController.text,
                            role: widget.role,
                          ),
                        ),
                      );
                    },
            )
          ],
        ),
      ),
    );
  }
}

