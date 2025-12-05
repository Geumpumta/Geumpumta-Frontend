import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptor extends Interceptor {
  final Dio dio;
  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  TokenInterceptor(this.dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 토큰 갱신 요청은 Authorization 헤더를 추가 X
    if (options.path == '/auth/token/refresh') {
      return handler.next(options);
    }

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 토큰 갱신 요청 자체가 실패한 경우 -> 그대로 전달
    if (err.requestOptions.path == '/auth/token/refresh') {
      return handler.next(err);
    }

    if (err.response?.statusCode == 401) {
      // 이미 갱신 중이면 대기열에 추가
      if (_isRefreshing) {
        return _addToPendingRequests(err, handler);
      }

      _isRefreshing = true;

      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');
      final oldAccessToken = prefs.getString('accessToken');

      if (refreshToken == null || oldAccessToken == null) {
        _isRefreshing = false;
        _rejectPendingRequests(err);
        return handler.next(err);
      }

      try {
        final refreshDio = Dio(BaseOptions(
          baseUrl: dio.options.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ));

        final res = await refreshDio.post(
          '/auth/token/refresh',
          data: {
            'accessToken': oldAccessToken,
            'refreshToken': refreshToken,
          },
        );

        final raw = res.data;
        Map<String, dynamic>? tokenData;
        
        if (raw is Map) {
          // success 필드 확인
          final success = raw['success'];
          final isSuccess = success == true || success == 'true';
          
          if (isSuccess && raw['data'] is Map) {
            // { success: "true", data: { accessToken, refreshToken } } 형태
            tokenData = raw['data'] as Map<String, dynamic>;
          } else if (raw['accessToken'] != null) {
            tokenData = raw as Map<String, dynamic>;
          }
        }

        if (tokenData == null) {
          throw Exception('토큰 갱신 응답 형식이 올바르지 않습니다: $raw');
        }

        final String? newAccessToken = tokenData['accessToken'];
        final String? newRefreshToken = tokenData['refreshToken'];

        if (newAccessToken != null) {
          await prefs.setString('accessToken', newAccessToken);
          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await prefs.setString('refreshToken', newRefreshToken);
          }

          // 원래 요청 재시도 해야함
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
          _isRefreshing = false;
          _rejectPendingRequests(err);
        }
      } catch (e) {
        // 토큰 갱신 실패 시 모든 토큰 삭제 (갱신 실패하면 로그아웃 처리)
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('accessToken');
        await prefs.remove('refreshToken');
        await prefs.remove('userInfo');
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
        pending.requestOptions.headers['Authorization'] =
            'Bearer $newAccessToken';
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
