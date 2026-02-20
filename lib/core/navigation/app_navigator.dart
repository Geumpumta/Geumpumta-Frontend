import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppNavigator {
  static NavigatorState? get _nav => rootNavigatorKey.currentState;

  static Future<void> goToForceEnded() async {
    await _nav?.pushNamedAndRemoveUntil('/study/force-ended', (r) => false);
  }
}
