import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:geumpumta/util/ios_channels.dart';
import 'package:geumpumta/widgets/error_dialog/error_dialog.dart';

class SetBlockAppIcon extends StatelessWidget {
  const SetBlockAppIcon({super.key});

  Future<void> _openPicker(BuildContext context) async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      ErrorDialog.show(
        context,
        'iOS에서만 지원되는 기능이에요.',
        title: '지원하지 않는 기능이에요',
      );
      return;
    }

    try {
      await IosFocusControl.requestAuthorization();
      await IosFocusControl.selectApps();
    } catch (_) {
      if (!context.mounted) {
        return;
      }
      ErrorDialog.show(
        context,
        'Family Controls API를 사용할 수 없어요.\n잠시 후 다시 시도해주세요.',
        title: '차단 앱 설정을 열 수 없어요',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _openPicker(context),
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
