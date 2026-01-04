import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rms_logistics/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow', () {
    testWidgets('User can navigate to login', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      expect(find.text('Customer Login'), findsOneWidget);
      expect(find.text('Driver Login'), findsOneWidget);
    });
  });
}

