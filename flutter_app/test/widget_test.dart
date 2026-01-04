import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rms_logistics/main.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: RMSApp()));
    expect(find.text('Welcome to RMS Logistics'), findsOneWidget);
  });
}

