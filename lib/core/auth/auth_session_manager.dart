import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_routes.dart';
import '../../widgets/common_dialog/common_dialog.dart';
import '../navigation/app_navigator.dart';

class AuthSessionManager {
  static bool _isHandlingSessionExpiry = false;
  static const String _defaultSessionExpiryMessage = '로그인 세션이 유효하지 않습니다.';
  static Future<void> Function()? onSessionCleared;

  static Future<void> clearLocalSession({bool clearFcmToken = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    await prefs.remove('userInfo');

    if (clearFcmToken) {
      try {
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp();
        }
        await FirebaseMessaging.instance.deleteToken();
      } catch (_) {
        // FCM cleanup failure should not block local logout.
      }
    }

    await onSessionCleared?.call();
  }

  static Future<void> handleSessionExpiry({
    String? message,
    String title = '로그인이 필요합니다',
    bool showDialog = false,
  }) async {
    if (_isHandlingSessionExpiry) {
      return;
    }
    _isHandlingSessionExpiry = true;

    await clearLocalSession(clearFcmToken: true);

    final nav = rootNavigatorKey.currentState;
    if (nav == null) {
      _isHandlingSessionExpiry = false;
      return;
    }

    nav.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);

    if (!showDialog) {
      _isHandlingSessionExpiry = false;
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = rootNavigatorKey.currentContext;
      if (context != null) {
        CommonDialog.show(
          context,
          title: title,
          message: (message == null || message.trim().isEmpty)
              ? _defaultSessionExpiryMessage
              : message.trim(),
          confirmText: '로그인하기',
        );
      }
      _isHandlingSessionExpiry = false;
    });
  }
}
