import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../api/fcm_api.dart';
import '../navigation/app_navigator.dart';
import 'local_notification_service.dart';

class FcmService {
  FcmService({
    required FirebaseMessaging messaging,
    required FcmApi fcmApi,
    required LocalNotificationService localNoti,
  })  : _messaging = messaging,
        _fcmApi = fcmApi,
        _localNoti = localNoti;

  final FirebaseMessaging _messaging;
  final FcmApi _fcmApi;
  final LocalNotificationService _localNoti;

  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedSub;

  bool _initialized = false;

  Future<void> initAndRegisterToken() async {
    if (_initialized) return;
    _initialized = true;

    await _requestPermission();
    await _localNoti.init();

    final token = await _messaging.getToken();
    if (token != null) {
      await _safeRegisterToken(token);
    }

    _tokenRefreshSub = _messaging.onTokenRefresh.listen((newToken) async {
      await _safeRegisterToken(newToken);
    });

    _onMessageSub = FirebaseMessaging.onMessage.listen((message) async {
      await _handleMessage(message, appOpenedByTap: false);
    });

    _onMessageOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await _handleMessage(message, appOpenedByTap: true);
    });

    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      await _handleMessage(initial, appOpenedByTap: true);
    }
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _safeRegisterToken(String token) async {
    try {
      await _fcmApi.registerToken(token: token);
    } catch (_) {
    }
  }

  Future<void> deleteTokenOnServer() async {
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

  Future<void> _handleMessage(RemoteMessage message, {required bool appOpenedByTap}) async {
    final data = message.data;

    final type = data['type'];

    if (type == 'STUDY_SESSION_FORCE_ENDED') {
      await AppNavigator.goToForceEnded();
      return;
    }

    if (!appOpenedByTap) {
      final title = message.notification?.title;
      final body = message.notification?.body;
      if (title != null && body != null) {
        await _localNoti.show(title: title, body: body);
      }
    }
  }
}
