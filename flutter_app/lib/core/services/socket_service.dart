import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;

  void connect(String token) {
    _socket = IO.io('http://10.0.2.2:5000/track', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'auth': {'token': token},
    });
    _socket?.connect();
  }

  void joinDelivery(String deliveryId) {
    _socket?.emit('join-delivery', {'deliveryId': deliveryId});
  }

  void sendLocation(String deliveryId, double lng, double lat) {
    _socket?.emit('location-update', {'deliveryId': deliveryId, 'lng': lng, 'lat': lat});
  }

  void onLocation(void Function(dynamic data) handler) {
    _socket?.on('location', handler);
  }

  void disconnect() {
    _socket?.disconnect();
  }
}

final socketService = SocketService();

