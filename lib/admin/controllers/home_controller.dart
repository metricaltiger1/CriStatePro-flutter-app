import 'package:cristatepro/user/controllers/user_profile_controler.dart';
import 'package:cristatepro/user/fragments/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:cristatepro/admin/controllers/message_controller.dart';
import 'package:cristatepro/admin/controllers/admin_house_controller.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:lottie/lottie.dart';

class AdminHomeController extends GetxController {
  final CurrentUser currentUser = Get.put(CurrentUser());
  final AdminHouseController houseController = Get.put(AdminHouseController());
  final UserProfileController controller = Get.put(UserProfileController());
  final MessageController messageController = Get.put(MessageController());

  final Rx<ImageProvider?> profileImage = Rx<ImageProvider?>(null);
  final RxString userName = ''.obs;
  final RxInt notifications = 0.obs;

  String get greeting => _getGreeting();

  @override
  void onInit() {
    super.onInit();

    initializeNotifications();
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

  void initializeNotifications() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
}
