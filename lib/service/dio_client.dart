import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart'; // 패키지 임포트
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'token_interceptor.dart';

Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(TokenInterceptor(dio));

  dio.interceptors.add(RetryInterceptor(
    dio: dio,
    logPrint: print,
    retries: 5,
    retryDelays: const [
      Duration(seconds: 1),
      Duration(seconds: 2),
      Duration(seconds: 3),
      Duration(seconds: 4),
      Duration(seconds: 5),
    ],
  ));

  return dio;
}