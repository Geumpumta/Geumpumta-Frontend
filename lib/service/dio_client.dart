import 'package:dio/dio.dart';
import 'token_interceptor.dart';

Dio createDioClient() {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://geumpumta.shop',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  ));
  dio.interceptors.add(TokenInterceptor());
  return dio;
}
