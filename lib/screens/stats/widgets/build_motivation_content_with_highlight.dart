import 'package:flutter/material.dart';

class BuildMotivationContentWithHighlight extends StatelessWidget {
  const BuildMotivationContentWithHighlight({
    super.key,
    required this.icon,
    required this.text,
    required this.highlightText,
  });

  final IconData icon;
  final String text;
  final String highlightText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF0BAEFF), size: 32),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Color(0xFF333333)),
              children: [
                TextSpan(text: text),
                TextSpan(
                  text: highlightText,
                  style: const TextStyle(
                    color: Color(0xFF0BAEFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
