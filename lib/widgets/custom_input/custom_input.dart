import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InputType { text, number, email }

class CustomInput extends StatelessWidget {
  const CustomInput({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.controller,
    this.hintText,
    this.inputType = InputType.text,
  });

  final String title;
  final String value;
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;
  final InputType inputType;

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType;
    List<TextInputFormatter>? formatters;

    switch (inputType) {
      case InputType.number:
        keyboardType = TextInputType.number;
        formatters = [FilteringTextInputFormatter.digitsOnly];
        break;
      case InputType.email:
        keyboardType = TextInputType.emailAddress;
        formatters = [];
        break;
      case InputType.text:
      default:
        keyboardType = TextInputType.text;
        formatters = [];
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          TextField(
            onChanged: onChanged,
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: formatters,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Color(0xFFBDBDBD),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFBDBDBD)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0BAEFF)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
