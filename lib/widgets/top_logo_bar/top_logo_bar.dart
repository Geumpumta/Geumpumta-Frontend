import 'package:flutter/material.dart';

class TopLogoBar extends StatelessWidget {
  const TopLogoBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        border: Border(
          bottom: BorderSide(
            color: Color(0x14000000),
            width: 2
          )
        )
      ),
      height: 120,
      child: Image.asset('assets/image/home/title_logo.png'),
    );
  }
}
