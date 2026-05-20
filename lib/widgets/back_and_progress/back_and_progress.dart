import 'package:flutter/material.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

class BackAndProgress extends StatelessWidget {
  const BackAndProgress({super.key, required this.percent, this.onBack});

  final double percent;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack ?? () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        LinearPercentIndicator(
          padding: EdgeInsets.zero,
          percent: percent,
          lineHeight: 8,
          backgroundColor: const Color(0xFFD9D9D9),
          progressColor: const Color(0xFF0BAEFF),
        ),
      ],
    );
  }
}
