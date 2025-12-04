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
    // 토큰 갱신 요청은 Authorization 헤더를 추가하지 않음
    if (options.path == '/auth/token/refresh') {
      print(
          '[TokenInterceptor][onRequest] refresh 호출 → Authorization 헤더 미설정, path=${options.path}');
      return handler.next(options);
    }

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
      print(
          '[TokenInterceptor][onRequest] AT 설정 완료 → ${options.method} ${options.uri}');
    } else {
      print(
          '[TokenInterceptor][onRequest] Access Token 없음 → Authorization 헤더 스킵, url=${options.uri}');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    print(
        '[TokenInterceptor][onError] statusCode=${err.response?.statusCode}, url=${err.requestOptions.uri}, path=${err.requestOptions.path}');

    // 토큰 갱신 요청 자체가 실패한 경우는 그대로 전달
    if (err.requestOptions.path == '/auth/token/refresh') {
      print('[TokenInterceptor][onError] refresh 요청 실패 → 그대로 에러 전달');
      return handler.next(err);
    }

    if (err.response?.statusCode == 401) {
      print('[TokenInterceptor] 401 발생 → AT 재발급 플로우 진입');

      // 이미 갱신 중이면 대기열에 추가
      if (_isRefreshing) {
        print(
            '[TokenInterceptor] 이미 갱신 중 → 현재 요청을 pending 큐에 추가 후 대기');
        return _addToPendingRequests(err, handler);
      }

      _isRefreshing = true;
      print('[TokenInterceptor] Access token expired, refreshing...');

      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');
      final oldAccessToken = prefs.getString('accessToken');
      print(
          '[TokenInterceptor] 저장된 refreshToken=${refreshToken != null ? '존재' : '없음'}, accessToken=${oldAccessToken != null ? '존재' : '없음'}');

      if (refreshToken == null || oldAccessToken == null) {
        print(
            '[TokenInterceptor] refreshToken 또는 accessToken 없음 → 재발급 불가, pending 요청들 실패 처리');
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

        print(
            '[TokenInterceptor] /auth/token/refresh 호출 시작, baseUrl=${dio.options.baseUrl}');

        final res = await refreshDio.post(
          '/auth/token/refresh',
          data: {
            'accessToken': oldAccessToken,
            'refreshToken': refreshToken,
          },
        );

        print(
            '[TokenInterceptor] /auth/token/refresh 응답 status=${res.statusCode}, data=${res.data}');

        // 서버 응답이 { success, data: { accessToken, refreshToken } } 형태일 수도 있고,
        // { accessToken, refreshToken } 바로 내려올 수도 있어 둘 다 케이스 처리
        final raw = res.data;
        final tokenData =
            (raw is Map && raw['data'] is Map) ? raw['data'] : raw;

        final String? newAccessToken = tokenData['accessToken'];
        final String? newRefreshToken = tokenData['refreshToken'];

        if (newAccessToken != null) {
          await prefs.setString('accessToken', newAccessToken);
          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await prefs.setString('refreshToken', newRefreshToken);
          }
          print(
              '[TokenInterceptor] Access Token refreshed! 새 AT/RT 저장 완료 → pending 요청들 재시도');

          // 원래 요청 재시도
          final retryRequest = err.requestOptions;
          retryRequest.headers['Authorization'] = 'Bearer $newAccessToken';

          print(
              '[TokenInterceptor] 실패했던 요청 재시도 → ${retryRequest.method} ${retryRequest.uri}');

          try {
            final retryResponse = await dio.fetch(retryRequest);
            print(
                '[TokenInterceptor] 재시도 응답 status=${retryResponse.statusCode}, data=${retryResponse.data}');
            _isRefreshing = false;
            _resolvePendingRequests(newAccessToken);
            return handler.resolve(retryResponse);
          } catch (e) {
            print('[TokenInterceptor] 재시도 중 예외 발생: $e');
            _isRefreshing = false;
            _rejectPendingRequests(err);
            return handler.next(err);
          }
        } else {
          print(
              "[TokenInterceptor] /auth/token/refresh 응답에 accessToken 없음 → 재발급 실패");
          _isRefreshing = false;
          _rejectPendingRequests(err);
        }
      } catch (e) {
        print('[TokenInterceptor] Token refresh failed: $e');
        // 토큰 갱신 실패 시 모든 토큰 삭제 (로그아웃 처리)
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('accessToken');
        await prefs.remove('refreshToken');
        await prefs.remove('userInfo');
        print('[TokenInterceptor] Tokens cleared due to refresh failure');
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
    print(
        '[TokenInterceptor][_addToPendingRequests] 요청 대기열 추가 → url=${err.requestOptions.uri}');
    _pendingRequests.add(_PendingRequest(err, handler));
  }

  void _resolvePendingRequests(String newAccessToken) async {
    print(
        '[TokenInterceptor][_resolvePendingRequests] pending 요청 수=${_pendingRequests.length}, 새 AT로 재시도 시작');
    for (final pending in _pendingRequests) {
      try {
        pending.requestOptions.headers['Authorization'] =
            'Bearer $newAccessToken';
        print(
            '[TokenInterceptor][_resolvePendingRequests] 재시도 → ${pending.requestOptions.method} ${pending.requestOptions.uri}');
        final response = await dio.fetch(pending.requestOptions);
        print(
            '[TokenInterceptor][_resolvePendingRequests] 재시도 응답 status=${response.statusCode}');
        pending.handler.resolve(response);
      } catch (e) {
        print(
            '[TokenInterceptor][_resolvePendingRequests] 재시도 중 예외 → $e, 원본 에러 전달');
        pending.handler.next(pending.error);
      }
    }
    _pendingRequests.clear();
  }

  void _rejectPendingRequests(DioException err) {
    print(
        '[TokenInterceptor][_rejectPendingRequests] pending 요청들 실패 처리, 개수=${_pendingRequests.length}');
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
