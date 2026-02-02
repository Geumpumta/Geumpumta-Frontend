import 'dart:io';
import 'package:flutter/services.dart';

class IosFocusControl {
  static const _channel = MethodChannel('focus_control');

  static bool get _isIOS => Platform.isIOS;

  static Future<void> requestAuthorization() async {
    if (!_isIOS) return;
    await _channel.invokeMethod('requestAuthorization');
  }

  static Future<void> selectApps() async {
    if (!_isIOS) return;
    await _channel.invokeMethod('selectApps');
  }

  static Future<void> startFocus() async {
    if (!_isIOS) return;
    await _channel.invokeMethod('startFocus');
  }

  static Future<void> stopFocus() async {
    if (!_isIOS) return;
    await _channel.invokeMethod('stopFocus');
  }
}

class IosNetworkMonitor {
  static const _channel = MethodChannel('network_monitor');
  static bool get _isIOS => Platform.isIOS;

  static void setListener(
      void Function(bool isWifi) onChanged,
      void Function() onLost,
      ) {
    if (!_isIOS) return;

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'network_changed') {
        final args = Map<String, dynamic>.from(call.arguments);

        if (args['type'] == 'changed') {
          onChanged(args['isWifi'] == true);
        } else if (args['type'] == 'lost') {
          onLost();
        }
      }
    });
  }
}
