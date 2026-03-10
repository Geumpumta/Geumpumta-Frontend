import 'package:dio/dio.dart';

class FcmApi {
  FcmApi(this._dio);
  final Dio _dio;

  Future<void> registerToken({required String token}) async {
    await _dio.post(
      '/api/v1/fcm/token',
      data: {
        // backend expects `fcmToken` (not `token`)
        'fcmToken': token,
      },
    );
  }

  Future<void> deleteToken() async {
    await _dio.delete('/api/v1/fcm/token');
  }
}
