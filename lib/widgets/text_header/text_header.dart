import 'package:flutter/material.dart';

class TextHeader extends StatelessWidget {
  const TextHeader({super.key, required this.text});

  final text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
