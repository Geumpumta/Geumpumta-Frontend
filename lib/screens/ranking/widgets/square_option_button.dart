import 'package:flutter/material.dart';

class SquareOptionButton extends StatelessWidget {
  const SquareOptionButton({
    super.key,
    required this.text,
    required this.isActive,
  });

  final String text;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        overlayColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        padding: EdgeInsets.zero,
        backgroundColor: isActive ? Color(0xFFEEEEEE) : Color(0xFFFFFFFF),
        fixedSize: Size(80, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      onPressed: () {},
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Color(0xFF000000) : Color(0xFF898989),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
