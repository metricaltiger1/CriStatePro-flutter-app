import 'package:cristatepro/configs/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController customTextFieldController;
  final String? hintText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final bool obscuredPassword;
  final bool isPassword;
  final int maxLines;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.customTextFieldController,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscuredPassword = false,
    this.isPassword = false,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: customTextFieldController,
        obscureText: obscuredPassword,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              style: BorderStyle.solid,
              color: appGrayColor,
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(color: appGrayColor),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
