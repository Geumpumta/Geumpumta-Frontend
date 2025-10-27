import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.value,
    required this.onActive,
    required this.controller
  });

  final String value;
  final TextEditingController? controller;
  final VoidCallback onActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFF5F5F5),
          isDense: true,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.search_rounded,
              color: Color(0xFFBDBDBD),
              size: 30,
            ),
            onPressed: onActive,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFBDBDBD)),
          ),
          hintText: '학과명을 입력해주세요.',
          hintStyle: TextStyle(color: Color(0xFFD9D9D9)),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFFFFF)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF0BAEFF)),
          ),
        ),
      ),
    );
  }
}
