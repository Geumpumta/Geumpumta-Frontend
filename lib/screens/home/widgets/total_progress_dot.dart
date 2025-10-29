import 'package:flutter/material.dart';
import 'package:geumpumta/screens/home/widgets/custom_dot.dart';

class TotalProgressDot extends StatefulWidget {
  const TotalProgressDot({super.key, required this.duration});
  final Duration duration;

  @override
  State<TotalProgressDot> createState() => _TotalProgressDotState();
}

class _TotalProgressDotState extends State<TotalProgressDot> {
  final int _maxHour = 20;

  @override
  Widget build(BuildContext context) {
    double progress = widget.duration.inHours / _maxHour;
    progress = progress.clamp(0.0, 1.0);

    int activeCount = (progress * 8).floor();

    final List<SizeOption> dotPattern = [
      SizeOption.small,
      SizeOption.big,
      SizeOption.small,
      SizeOption.big,
      SizeOption.small,
      SizeOption.big,
      SizeOption.small,
      SizeOption.big,
    ];

    return Container(
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 15,
        children: List.generate(dotPattern.length, (index) {
          return CustomDot(
            size: dotPattern[index],
            isActivate: index < activeCount,
          );
        }),
      ),
    );
  }
}
