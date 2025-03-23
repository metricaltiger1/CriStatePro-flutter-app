import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final bool? centerTitle;

  const CustomAppBar({
    super.key,
    this.title,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title!,
        style: TextStyle(
            color: Theme.of(context).appBarTheme.titleTextStyle?.color),
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0.0,
      centerTitle: centerTitle,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
          margin: const EdgeInsets.all(2),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Theme.of(context).appBarTheme.backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ),
        ),
      ),
    );
  }
}
