import 'package:cristatepro/configs/constants.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String buttonName;
  final Color color;
  final double buttonWidth;
  final double buttonHeight;
  final VoidCallback? action;
  final Widget? destinationScreen;

  const CustomTextButton({
    super.key,
    required this.buttonName,
    this.action,
    this.color = primaryColor,
    this.buttonHeight = 50,
    this.buttonWidth = 200,
    this.destinationScreen,
    required TextStyle textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationScreen!),
        );
      },
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        alignment: Alignment.center,
        child: Text(
          buttonName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: appWhiteColor,
          ),
        ),
      ),
    );
  }
}
