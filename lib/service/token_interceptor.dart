import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    } else {
      print('⚠Access Token not found, skipping Authorization header.');
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      print('Token expired — trying to refresh...');

      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');

      if (refreshToken != null) {
        try {
          final dio = Dio();
          final res = await dio.post(
            'https://geumpumta.shop:8080/auth/token/refresh',
            data: {'refreshToken': refreshToken},
          );

          if (res.statusCode == 200 && res.data['accessToken'] != null) {
            final newAccessToken = res.data['accessToken'];
            await prefs.setString('accessToken', newAccessToken);
            print('Access Token refreshed!');

            final retryRequest = err.requestOptions;
            retryRequest.headers['Authorization'] = 'Bearer $newAccessToken';

            final response = await dio.fetch(retryRequest);
            return handler.resolve(response);
          }
        } catch (e) {
          print('Failed to refresh token: $e');
        }
      }
    }

    super.onError(err, handler);
  }
}
