import 'package:flutter/material.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

class BackAndProgress extends StatelessWidget {
  const BackAndProgress({super.key, required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
              ),
            ],
          ),
        ),
        SizedBox(height: 6),
        LinearPercentIndicator(
          padding: EdgeInsets.zero,
          percent: percent,
          lineHeight: 8,
          backgroundColor: Color(0xFFD9D9D9),
          progressColor: Color(0xFF0BAEFF),
        ),
      ],
    );
  }
}
