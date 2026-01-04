import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_colors.dart';
import 'features/auth/views/startup_view.dart';

void main() {
  runApp(const ProviderScope(child: RMSApp()));
}

class RMSApp extends StatelessWidget {
  const RMSApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RMS Logistics',
      theme: ThemeData(
        primarySwatch: AppColors.primarySwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const StartupView(),
      debugShowCheckedModeBanner: false,
    );
  }
}

