import 'package:cristatepro/user/controllers/user_profile_controler.dart';
import 'package:cristatepro/user/fragments/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:lottie/lottie.dart';

class HomeScreenController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final UserProfileController controller = Get.put(UserProfileController());

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Widget buildProfileImage(CurrentUser currentUser) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double imageSize = constraints.maxWidth * 0.5;

        return GestureDetector(
          onTap: () {
            Get.to(() => ProfileImagePreview(
                imageData: currentUser.user.userProfileImageData!));
          },
          child: Obx(() {
            return Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: imageSize,
                  backgroundColor: Colors.white,
                  backgroundImage: currentUser.user.userProfileImageData != null
                      ? MemoryImage(currentUser.user.userProfileImageData!)
                      : const AssetImage('assets/user.png') as ImageProvider,
                ),
                if (controller.imageUpdated)
                  Lottie.asset(
                    'assets/progressbar.json',
                    width: 60,
                    height: 60,
                  ),
              ],
            );
          }),
        );
      },
    );
  }
}
