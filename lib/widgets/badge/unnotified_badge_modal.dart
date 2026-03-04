import 'package:flutter/material.dart';
import 'package:geumpumta/models/entity/badge/unnotified_badge.dart';

class UnnotifiedBadgeModal extends StatelessWidget {
  const UnnotifiedBadgeModal({super.key, required this.badge});

  final UnnotifiedBadge badge;

  static Future<void> showSequence(
    BuildContext context,
    List<UnnotifiedBadge> badges,
  ) async {
    for (final badge in badges) {
      await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (_) => UnnotifiedBadgeModal(badge: badge),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '새 배지를 획득했어요!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 96,
                height: 96,
                child: Image.network(
                  badge.iconUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFECEFF1),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.emoji_events_rounded,
                      size: 44,
                      color: Color(0xFF607D8B),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              badge.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF616161)),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0BAEFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
