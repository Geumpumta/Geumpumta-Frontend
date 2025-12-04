import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;
  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  TokenInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 토큰 갱신 요청은 Authorization 헤더를 추가하지 않음
    if (options.path == '/auth/token/refresh') {
      return handler.next(options);
    }

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
    // 토큰 갱신 요청 자체가 실패한 경우는 그대로 전달
    if (err.requestOptions.path == '/auth/token/refresh') {
      return handler.next(err);
    }

    if (err.response?.statusCode == 401) {
      // 이미 갱신 중이면 대기열에 추가
      if (_isRefreshing) {
        return _addToPendingRequests(err, handler);
      }

      _isRefreshing = true;
      print('Access token expired, refreshing...');

      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');

      if (refreshToken == null) {
        print('No refresh token found → cannot refresh');
        _isRefreshing = false;
        _rejectPendingRequests(err);
        return handler.next(err);
      }

      try {
        // 토큰 갱신 요청은 Authorization 헤더 없이 별도로 처리
        final refreshDio = Dio(BaseOptions(
          baseUrl: dio.options.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ));

        final res = await refreshDio.post(
          '/auth/token/refresh',
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = res.data['accessToken'];

        if (newAccessToken != null) {
          await prefs.setString('accessToken', newAccessToken);
          print('Access Token refreshed!');

          // 원래 요청 재시도
          final retryRequest = err.requestOptions;
          retryRequest.headers['Authorization'] = 'Bearer $newAccessToken';

          try {
            final retryResponse = await dio.fetch(retryRequest);
            _isRefreshing = false;
            _resolvePendingRequests(newAccessToken);
            return handler.resolve(retryResponse);
          } catch (e) {
            _isRefreshing = false;
            _rejectPendingRequests(err);
            return handler.next(err);
          }
        } else {
          print("refresh API did not return accessToken");
          _isRefreshing = false;
          _rejectPendingRequests(err);
        }
      } catch (e) {
        print('Token refresh failed: $e');
        // 토큰 갱신 실패 시 모든 토큰 삭제 (로그아웃 처리)
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('accessToken');
        await prefs.remove('refreshToken');
        await prefs.remove('userInfo');
        print('Tokens cleared due to refresh failure');
        _isRefreshing = false;
        _rejectPendingRequests(err);
      }
    }

    handler.next(err);
  }

  void _addToPendingRequests(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    _pendingRequests.add(_PendingRequest(err, handler));
  }

  void _resolvePendingRequests(String newAccessToken) async {
    for (final pending in _pendingRequests) {
      try {
        pending.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        final response = await dio.fetch(pending.requestOptions);
        pending.handler.resolve(response);
      } catch (e) {
        pending.handler.next(pending.error);
      }
    }
    _pendingRequests.clear();
  }

  void _rejectPendingRequests(DioException err) {
    for (final pending in _pendingRequests) {
      pending.handler.next(err);
    }
    _pendingRequests.clear();
  }
}

class _PendingRequest {
  final DioException error;
  final ErrorInterceptorHandler handler;

  RequestOptions get requestOptions => error.requestOptions;

  _PendingRequest(this.error, this.handler);
}
