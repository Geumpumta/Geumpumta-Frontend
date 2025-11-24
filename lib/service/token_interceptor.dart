import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;

  TokenInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    } else {
      print('Access Token not found, skipping Authorization header.');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      print('Access token expired, refreshing...');

      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');

      if (refreshToken == null) {
        print('No refresh token found → cannot refresh');
        return handler.next(err);
      }

      try {
        final res = await dio.post(
          '/auth/token/refresh',
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = res.data['accessToken'];

        if (newAccessToken != null) {
          await prefs.setString('accessToken', newAccessToken);
          print('Access Token refreshed!');

          final retryRequest = err.requestOptions;
          retryRequest.headers['Authorization'] = 'Bearer $newAccessToken';

          final retryResponse = await dio.fetch(retryRequest);

          return handler.resolve(retryResponse);
        } else {
          print("refresh API did not return accessToken");
        }
      } catch (e) {
        print('Token refresh failed: $e');
      }
    }

    handler.next(err);
  }
}
