import 'dart:async';
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
  })  : _fcmApi = fcmApi,
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
    if (_initialized) return;
    await _ensureFirebaseInitialized();
    _initialized = true;

    final settings = await _requestPermission();
    await _localNoti.init();

    final isAuthorized =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;

    if (isAuthorized) {
      await _registerTokenWhenAvailable();
    }

    _tokenRefreshSub = _messaging.onTokenRefresh.listen((newToken) async {
      await _safeRegisterToken(newToken);
    });

    _onMessageSub = FirebaseMessaging.onMessage.listen((message) async {
      await _handleMessage(message);
    });

    _onMessageOpenedSub =
        FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await _handleMessage(message);
    });

    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      await _handleMessage(initial);
    }
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
    } catch (_) {
    }
  }

  Future<void> _registerTokenWhenAvailable() async {
    for (int attempt = 0; attempt < 6; attempt++) {
      final token = await _getTokenSafely();
      if (token != null && token.isNotEmpty) {
        await _safeRegisterToken(token);
        return;
      }

      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<String?> _getTokenSafely() async {
    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        final apnsToken = await _messaging.getAPNSToken();
        if (apnsToken == null || apnsToken.isEmpty) {
          return null;
        }
      }
      return await _messaging.getToken();
    } on FirebaseException catch (e) {
      if (e.code == 'apns-token-not-set') {
        return null;
      }
      rethrow;
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteTokenOnServer() async {
    await _ensureFirebaseInitialized();

    try {
      await _fcmApi.deleteToken();
    } catch (_) {}

    try { await _messaging.deleteToken(); } catch (_) {}
  }

  Future<void> dispose() async {
    await _tokenRefreshSub?.cancel();
    await _onMessageSub?.cancel();
    await _onMessageOpenedSub?.cancel();
    _initialized = false;
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    final notification = message.notification;
    final notificationBody = notification?.body;
    if (notificationBody != null && notificationBody.isNotEmpty) {
      final context = rootNavigatorKey.currentContext;
      if (context != null) {
        final title = notification?.title ?? '알림';
        NotificationDialog.show(context, title: title, body: notificationBody);
      }
    }

    final data = message.data;

    final type = data['type'];

    if (type == 'STUDY_SESSION_FORCE_ENDED') {
      await _refreshStudyState();
      await AppNavigator.goToForceEnded();
      return;
    }
  }

  Future<void> _refreshStudyState() async {
    final response = await _ref.read(studyViewmodelProvider).getStudyTime();
    if (response != null) {
      final totalMillis = response.data.totalStudySession;
      await _ref
          .read(userInfoStateProvider.notifier)
          .updateTotalMillis(totalMillis);
    }

    _ref.read(studyRunningProvider.notifier).state = false;
  }

  Future<void> _ensureFirebaseInitialized() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  }
}
