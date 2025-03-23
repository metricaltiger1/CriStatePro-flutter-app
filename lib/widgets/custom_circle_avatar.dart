import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCircleAvatar extends StatelessWidget {
  final double radius;
  final String imagePath;

  const CustomCircleAvatar({
    super.key,
    required this.radius,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AvatarController>(
      builder: (controller) {
        return CircleAvatar(
          radius: radius,
          backgroundImage: AssetImage(controller.imagePath as String),
        );
      },
    );
  }
}

class AvatarController extends GetxController {
  var imagePath = 'assets/default_profile_image.jpg'.obs;
}
