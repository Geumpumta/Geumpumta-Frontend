import 'dart:convert';

import 'package:flutter/material.dart';

import '../navigation/app_navigator.dart';

class MaintenanceGuard {
  static const String maintenanceCode = 'MT001';
  static const String _defaultMessage = '서버 점검 중입니다.';
  static bool _isShowing = false;

  static bool isMaintenancePayload(dynamic payload) {
    final map = _toMap(payload);
    if (map == null) return false;
    return map['code']?.toString() == maintenanceCode;
  }

  static void showIfMaintenance(dynamic payload) {
    final map = _toMap(payload);
    if (map == null) return;

    if (map['code']?.toString() != maintenanceCode) {
      return;
    }

    final message =
        (map['msg'] ?? map['message'])?.toString().trim() ?? _defaultMessage;
    _showDialog(message.isEmpty ? _defaultMessage : message);
  }

  static void _showDialog(String message) {
    if (_isShowing) return;

    final context = rootNavigatorKey.currentState?.overlay?.context;
    if (context == null) return;

    _isShowing = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dialogContext = rootNavigatorKey.currentState?.overlay?.context;
      if (dialogContext == null) {
        _isShowing = false;
        return;
      }

      showDialog<void>(
        context: dialogContext,
        barrierDismissible: false,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '서비스 점검 중입니다',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.55,
                      color: Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '앱을 종료한 뒤 잠시 후 다시 실행해 주세요.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7A7A7A),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).whenComplete(() {
        _isShowing = false;
      });
    });
  }

  static Map<String, dynamic>? _toMap(dynamic payload) {
    if (payload is Map<String, dynamic>) return payload;

    if (payload is Map) {
      return payload.map((key, value) => MapEntry(key.toString(), value));
    }

    if (payload is String && payload.isNotEmpty) {
      try {
        final decoded = jsonDecode(payload);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) {
          return decoded.map((key, value) => MapEntry(key.toString(), value));
        }
      } catch (_) {}
    }
    return null;
  }
}
