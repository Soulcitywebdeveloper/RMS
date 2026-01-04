import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import 'dart:convert';

final authProvider = StateNotifierProvider<AuthViewModel, AsyncValue<Map<String, dynamic>?>>(
  (ref) => AuthViewModel(),
);

class AuthViewModel extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  AuthViewModel() : super(const AsyncValue.data(null));

  Future<void> login(String phone, String otp) async {
    state = const AsyncValue.loading();
    try {
      final response = await apiService.post('/auth/login', data: {
        'phone': phone,
        'otp': otp,
      });
      final token = response.data['token'];
      final refresh = response.data['refresh'];
      apiService.setToken(token);
      // Decode JWT payload for role/claims (insecure for prod, but fine for role routing)
      final parts = token.split('.');
      final payload = json.decode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
      state = AsyncValue.data({
        'token': token,
        'refresh': refresh,
        'role': payload['role'],
      });
    } catch (e) {
      state = AsyncValue.error('Login failed');
    }
  }
}
