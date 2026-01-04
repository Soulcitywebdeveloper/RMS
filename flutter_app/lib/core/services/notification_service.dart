import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<String?> getToken() async => await _fcm.getToken();

  void init() {
    FirebaseMessaging.onMessage.listen((msg) {
      // Handle foreground push notifications
    });
  }
}

final notificationService = NotificationService();

