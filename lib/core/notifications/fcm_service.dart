import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/fcm_api.dart';
import '../navigation/app_navigator.dart';
import 'local_notification_service.dart';
import '../../provider/study/study_provider.dart';
import '../../viewmodel/study/study_viewmodel.dart';
import '../../provider/userState/user_info_state.dart';
import '../../widgets/notification_dialog/notification_dialog.dart';

class FcmService {
  FcmService({
    required FcmApi fcmApi,
    required LocalNotificationService localNoti,
    required Ref ref,
  }) : _fcmApi = fcmApi,
       _localNoti = localNoti,
       _ref = ref;

  final FcmApi _fcmApi;
  final LocalNotificationService _localNoti;
  final Ref _ref;
  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedSub;

  bool _initialized = false;

  Future<void> initAndRegisterToken() async {
    if (_initialized) {
      _log('init skipped: already initialized, retry token register');
      await _registerTokenWhenAvailable();
      return;
    }
    _log('init start');
    await _ensureFirebaseInitialized();
    _initialized = true;

    final settings = await _requestPermission();
    _log('permission status: ${settings.authorizationStatus.name}');
    await _localNoti.init();
    _log('local notification initialized');

    final isAuthorized =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (isAuthorized) {
      _log('permission granted: register token');
      await _registerTokenWhenAvailable();
    } else {
      _log('permission denied/provisional not granted: token register skipped');
    }

    _tokenRefreshSub = _messaging.onTokenRefresh.listen((newToken) async {
      _log('onTokenRefresh received: ${_maskToken(newToken)}');
      await _safeRegisterToken(newToken);
    });

    _onMessageSub = FirebaseMessaging.onMessage.listen((message) async {
      await _handleMessage(message, source: 'onMessage');
    });

    _onMessageOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen((
      message,
    ) async {
      await _handleMessage(message, source: 'onMessageOpenedApp');
    });

    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      await _handleMessage(initial, source: 'getInitialMessage');
    } else {
      _log('getInitialMessage: none');
    }
    _log('init done');
  }

  Future<void> registerCurrentTokenToServer({String reason = 'manual'}) async {
    await _ensureFirebaseInitialized();
    final token = await _getTokenSafely();
    if (token == null || token.isEmpty) {
      _log('registerCurrentTokenToServer skipped ($reason): token unavailable');
      return;
    }

    _log('registerCurrentTokenToServer start ($reason): ${_maskToken(token)}');
    await _safeRegisterToken(token);
  }

  Future<NotificationSettings> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    return settings;
  }

  Future<void> _safeRegisterToken(String token) async {
    try {
      await _fcmApi.registerToken(token: token);
      _log('token registered: ${_maskToken(token)}');
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      _log('token register failed: status=$status, type=${e.type}, data=$data');
    } catch (e) {
      _log('token register failed: $e');
    }
  }

  Future<void> _registerTokenWhenAvailable() async {
    for (int attempt = 0; attempt < 6; attempt++) {
      final token = await _getTokenSafely();
      if (token != null && token.isNotEmpty) {
        _log('token acquired at attempt ${attempt + 1}: ${_maskToken(token)}');
        await _safeRegisterToken(token);
        return;
      }

      _log('token not ready at attempt ${attempt + 1}');
      await Future.delayed(const Duration(seconds: 1));
    }
    _log('token acquire failed after max attempts');
  }

  Future<String?> _getTokenSafely() async {
    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null || apnsToken.isEmpty) {
          _log('APNS token not ready');
          return null;
        }
        _log('APNS token ready');
      }
      return await _messaging.getToken();
    } on FirebaseException catch (e) {
      if (e.code == 'apns-token-not-set') {
        _log('getToken skipped: apns-token-not-set');
        return null;
      }
      _log('getToken FirebaseException: ${e.code}');
      rethrow;
    } catch (_) {
      _log('getToken failed');
      return null;
    }
  }

  Future<void> deleteTokenOnServer() async {
    await _ensureFirebaseInitialized();

    try {
      await _fcmApi.deleteToken();
      _log('server token deleted');
    } catch (_) {
      _log('server token delete failed');
    }

    try {
      await _messaging.deleteToken();
      _log('local token deleted');
    } catch (_) {
      _log('local token delete failed');
    }
  }

  Future<void> dispose() async {
    await _tokenRefreshSub?.cancel();
    await _onMessageSub?.cancel();
    await _onMessageOpenedSub?.cancel();
    _initialized = false;
    _log('disposed');
  }

  Future<void> _handleMessage(
    RemoteMessage message, {
    required String source,
  }) async {
    _log(
      'message received [$source] id=${message.messageId} '
      'type=${message.data['type']} hasNotification=${message.notification != null}',
    );

    final notification = message.notification;
    final notificationBody = notification?.body;
    if (notificationBody != null && notificationBody.isNotEmpty) {
      final context = rootNavigatorKey.currentContext;
      if (context != null) {
        final title = notification?.title ?? '알림';
        NotificationDialog.show(context, title: title, body: notificationBody);
        _log('notification dialog shown: "$title"');
      } else {
        _log('notification dialog skipped: no navigator context');
      }
    }

    final data = message.data;

    final type = data['type'];

    if (type == 'STUDY_SESSION_FORCE_ENDED') {
      _log('force-ended message handling start');
      await _refreshStudyState();
      _log('study state refreshed');
      await AppNavigator.goToForceEnded();
      _log('navigated to force-ended screen');
      return;
    }

    _log('message ignored: unsupported type');
  }

  Future<void> _refreshStudyState() async {
    final response = await _ref.read(studyViewmodelProvider).getStudyTime();
    if (response != null) {
      final totalMillis = response.data.totalStudySession;
      final isStudying = response.data.isStudying;
      await _ref
          .read(userInfoStateProvider.notifier)
          .updateTotalMillis(totalMillis);
      _ref.read(studyRunningProvider.notifier).state = isStudying;
      _log(
        'study state synced: totalMillis=$totalMillis, isStudying=$isStudying',
      );
    } else {
      _log('study state sync failed: null response');
      _ref.read(studyRunningProvider.notifier).state = false;
      _log('studyRunningProvider set to false (fallback)');
    }
  }

  Future<void> _ensureFirebaseInitialized() async {
    if (Firebase.apps.isEmpty) {
      _log('Firebase initializeApp');
      await Firebase.initializeApp();
    }
  }

  void _log(String message) {
    debugPrint('[FCM] $message');
  }

  String _maskToken(String token) {
    if (token.length <= 12) return token;
    return '${token.substring(0, 6)}...${token.substring(token.length - 6)}';
  }
}
