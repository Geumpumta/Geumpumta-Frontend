import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/auth/auth_session_manager.dart';
import '../core/maintenance/maintenance_guard.dart';

class TokenInterceptor extends Interceptor {
  static const String _sessionInvalidCode = 'S007';

  final Dio dio;
  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  TokenInterceptor(this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
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
    if (MaintenanceGuard.isMaintenancePayload(err.response?.data)) {
      MaintenanceGuard.showIfMaintenance(err.response?.data);
      return handler.next(err);
    }

    // 토큰 갱신 요청 자체가 실패한 경우 -> 그대로 전달
    if (err.requestOptions.path == '/auth/token/refresh') {
      return handler.next(err);
    }

    if (err.response?.statusCode == 401) {
      final errorCode = _extractErrorCode(err.response?.data);
      if (errorCode == _sessionInvalidCode) {
        final prefs = await SharedPreferences.getInstance();
        final storedAccessToken = prefs.getString('accessToken');
        final storedRefreshToken = prefs.getString('refreshToken');
        final requestUri = err.requestOptions.uri;
        debugPrint(
          '[AUTH][S007] api=${err.requestOptions.method} '
          '${err.requestOptions.path} '
          '(url=$requestUri)',
        );
        debugPrint(
          '[AUTH][S007] response='
          'status=${err.response?.statusCode}, '
          'code=$errorCode, '
          'message=${_extractErrorMessage(err.response?.data)}, '
          'data=${err.response?.data}',
        );
        debugPrint(
          '[AUTH][S007] storedTokens='
          'access=${_maskToken(storedAccessToken)}, '
          'refresh=${_maskToken(storedRefreshToken)}',
        );

        _isRefreshing = false;
        _rejectPendingRequests(err);
        await AuthSessionManager.handleSessionExpiry(
          message: _extractErrorMessage(err.response?.data),
          showDialog: true,
        );
        return handler.next(err);
      }

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
        await AuthSessionManager.handleSessionExpiry();
        return handler.next(err);
      }

      try {
        final refreshDio = Dio(
          BaseOptions(
            baseUrl: dio.options.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {'Content-Type': 'application/json'},
          ),
        );

        final res = await refreshDio.post(
          '/auth/token/refresh',
          data: {'accessToken': oldAccessToken, 'refreshToken': refreshToken},
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
          if (newRefreshToken != null) {
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
          await AuthSessionManager.handleSessionExpiry();
        }
      } catch (e) {
        _isRefreshing = false;
        _rejectPendingRequests(err);
        await AuthSessionManager.handleSessionExpiry();
      }
    }

    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    MaintenanceGuard.showIfMaintenance(response.data);
    handler.next(response);
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

  String? _extractErrorCode(dynamic payload) {
    final map = _toMap(payload);
    return map?['code']?.toString();
  }

  String? _extractErrorMessage(dynamic payload) {
    final map = _toMap(payload);
    return (map?['message'] ?? map?['msg'])?.toString();
  }

  String _maskToken(String? token) {
    if (token == null || token.isEmpty) {
      return 'missing';
    }
    if (token.length <= 12) {
      return token;
    }
    return '${token.substring(0, 6)}...${token.substring(token.length - 6)}';
  }

  Map<String, dynamic>? _toMap(dynamic payload) {
    if (payload is Map<String, dynamic>) {
      return payload;
    }

    if (payload is Map) {
      return payload.map((key, value) => MapEntry(key.toString(), value));
    }

    if (payload is String && payload.isNotEmpty) {
      try {
        final decoded = jsonDecode(payload);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
        if (decoded is Map) {
          return decoded.map((key, value) => MapEntry(key.toString(), value));
        }
      } catch (_) {}
    }

    return null;
  }
}

class _PendingRequest {
  final DioException error;
  final ErrorInterceptorHandler handler;

  RequestOptions get requestOptions => error.requestOptions;

  _PendingRequest(this.error, this.handler);
}
