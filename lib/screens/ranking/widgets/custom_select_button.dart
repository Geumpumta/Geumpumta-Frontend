import 'package:flutter/material.dart';

class CustomSelectButton extends StatelessWidget {
  const CustomSelectButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.onClick
  });

  final String text;
  final bool isActive;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        overlayColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      onPressed: onClick,
      child: Container(
        width: 90,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          border: isActive
              ? Border(bottom: BorderSide(width: 2, color: Color(0xFF000000)))
              : Border(),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isActive ? Color(0xFF000000) : Color(0xFF898989),
          ),
        ),
      ),
    );
  }
}
