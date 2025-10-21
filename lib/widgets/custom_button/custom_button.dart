import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.onActive = false,
  });

  final String buttonText;
  final VoidCallback? onPressed;
  final bool onActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(380, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: onActive ? Color(0xFF0BAEFF):Color(0xFFD9D9D9)
        ),
        onPressed: onActive ? onPressed : null,
        child: Text(buttonText, style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 16, fontWeight: FontWeight.w800),),
      ),
    );
  }
}
