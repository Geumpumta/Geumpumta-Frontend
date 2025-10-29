import 'package:flutter/material.dart';

enum SizeOption {big,small}

class CustomDot extends StatelessWidget {
  const CustomDot({super.key, required this.size, required this.isActivate});
  final SizeOption size;
  final bool isActivate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size==SizeOption.small?12:20,
      height: size==SizeOption.small?12:20,
      decoration: BoxDecoration(
        color: isActivate?Color(0xFF0BAEFF):Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
