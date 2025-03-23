import 'package:cristatepro/user/controllers/user_profile_controler.dart';
import 'package:cristatepro/user/fragments/profile_image.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:cristatepro/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class UserProfileFragmentScreen extends StatelessWidget {
  final UserProfileController controller = Get.put(UserProfileController());

  UserProfileFragmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CurrentUser currentUser = Get.find<CurrentUser>();
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.white60),
    );

    void prefillData() {
      controller.firstNameController.text = currentUser.user.userFirstName;
      controller.lastNameController.text = currentUser.user.userLastName;
      controller.phoneController.text = currentUser.user.userNumber.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(
          title: "Profile",
          centerTitle: true,
        ),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                controller.deleteUserProfilePicture();
              } else if (value == 'edit') {
                controller.setEditing(!controller.isEditing.value);
                prefillData();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit, color: Colors.blue),
                    title: Text('Edit Profile'),
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete Profile Photo'),
                  ),
                ),
              ];
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: Obx(() {
        final controller = Get.find<UserProfileController>();
        bool isEditing = controller.isEditing.value;

        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/profile.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Stack(
                    children: [
                      buildProfileImage(currentUser),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            controller.updateUserProfilePicture(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(
                  () => Column(
                    children: [
                      const SizedBox(height: 20),
                      userInfoItemProfile(
                        Icons.person,
                        "${currentUser.user.userFirstName} ${currentUser.user.userLastName}",
                      ),
                      const SizedBox(height: 20),
                      userInfoItemProfile(
                        Icons.phone,
                        '+254 ${currentUser.user.userNumber.toString()}',
                      ),
                      const SizedBox(height: 20),
                      userInfoItemProfile(
                        Icons.email,
                        currentUser.user.userEmail,
                      ),
                      const SizedBox(height: 20),
                      userInfoItemProfile(
                        Icons.date_range,
                        currentUser.user.userRegistrationDate,
                      ),
                      const SizedBox(height: 20),
                      Visibility(
                        visible: isEditing,
                        child: Column(
                          children: [
                            TextField(
                              controller: controller.firstNameController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                hintText: "First Name",
                                border: border,
                                enabledBorder: border,
                                focusedBorder: border,
                                disabledBorder: border,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                fillColor: Colors.white,
                                filled: true,
                                errorStyle: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: controller.lastNameController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                hintText: "Last Name",
                                border: border,
                                enabledBorder: border,
                                focusedBorder: border,
                                disabledBorder: border,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: controller.phoneController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.phone,
                                  color: Colors.black,
                                ),
                                hintText: "Phone",
                                border: border,
                                enabledBorder: border,
                                focusedBorder: border,
                                disabledBorder: border,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isEditing,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                bool success =
                                    await controller.updateUserInfo();
                                if (success) {
                                  controller.setEditing(false);
                                }
                              },
                              child: const Text('Save Changes'),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                controller.setEditing(false);
                                controller.firstNameController.clear();
                                controller.lastNameController.clear();
                                controller.phoneController.clear();
                              },
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget userInfoItemProfile(IconData iconData, String userData) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(iconData, color: Colors.black87, size: 30),
          const SizedBox(width: 16),
          Text(
            userData,
            style: const TextStyle(
              fontSize: 18,
              decoration: TextDecoration.none,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileImage(CurrentUser currentUser) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double imageSize = constraints.maxWidth * 0.2;

        return GestureDetector(
          onTap: () {
            Get.to(() => ProfileImagePreview(
                imageData: currentUser.user.userProfileImageData!));
          },
          child: Obx(() {
            final controller = Get.find<UserProfileController>();
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
