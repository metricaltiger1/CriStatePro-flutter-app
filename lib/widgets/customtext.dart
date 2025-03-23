import 'package:cristatepro/configs/constants.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String label;
  final Color lableColor;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomText({
    super.key,
    required this.label,
    this.lableColor = appGrayColor,
    this.fontSize = 24,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text(
        label,
        style: TextStyle(
          color: lableColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
