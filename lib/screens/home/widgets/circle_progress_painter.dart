import 'dart:math';
import 'package:flutter/material.dart';

class CircleProgressPainter extends CustomPainter {
  final double progress;
  CircleProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final Paint backgroundPaint = Paint()
      ..color = const Color(0x4C0BAEFF)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: 2 * pi,
      colors: const [
        Color(0xFF0BAEFF),
        Color(0xFF176CC7),
      ],
      transform: GradientRotation(-pi / 2),
      tileMode: TileMode.clamp,
    );

    final Paint progressPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    final double endX = center.dx + radius * cos(startAngle + sweepAngle);
    final double endY = center.dy + radius * sin(startAngle + sweepAngle);
    final Offset endPoint = Offset(endX, endY);
    canvas.drawCircle(endPoint, 10, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
