import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:5000',
      connectTimeout: Duration(seconds: 15),
      receiveTimeout: Duration(seconds: 20),
    ),
  );
  
  setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<Response> post(String path, {dynamic data}) async => _dio.post(path, data: data);
  Future<Response> get(String path) async => _dio.get(path);
  Future<Response> put(String path, {dynamic data}) async => _dio.put(path, data: data);
  // ... add others as needed
}

final apiService = ApiService();

