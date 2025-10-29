import 'package:flutter/material.dart';

import 'circle_progress_painter.dart';

class CustomTimerWidget extends StatefulWidget {
  const CustomTimerWidget({super.key, required this.duration});

  final Duration duration;

  @override
  State<CustomTimerWidget> createState() => _CustomTimerWidgetState();
}

class _CustomTimerWidgetState extends State<CustomTimerWidget> {
  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final progress = (widget.duration.inMinutes % 60) / 60.0;

    return Container(
        width: 270,
        height: 270,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFECF5F9),
          borderRadius: const BorderRadius.all(Radius.circular(150)),
        ),
        child: Container(
          width: 230,
          height: 230,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(150)),
          ),
          child: CustomPaint(
            painter: CircleProgressPainter(progress: progress),
            child: Center(
              child: Text(
                _formatDuration(widget.duration),
                style: const TextStyle(
                  color: Color(0xFF0BAEFF),
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ));
    }
}
