import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geumpumta/util/ios_channels.dart';
import 'package:geumpumta/util/focus_setup_store.dart';

class SetBlockAppIcon extends StatelessWidget {
  const SetBlockAppIcon({super.key});

  Future<void> _openBlockAppPicker(BuildContext context) async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('iOS에서만 지원되는 기능이에요.')),
      );
      return;
    }

    try {
      await IosFocusControl.requestAuthorization();
      await IosFocusControl.selectApps();
      await FocusSetupStore.setDone(true);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('차단 앱 설정 화면을 열었어요.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('차단 앱 설정을 열지 못했어요: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _openBlockAppPicker(context),
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[600],
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        splashFactory: NoSplash.splashFactory,
      ),
      icon: const Icon(Icons.shield_outlined, size: 18),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            '차단 앱 설정',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 4),
          Icon(Icons.chevron_right, size: 18),
        ],
      ),
    );
  }
}
