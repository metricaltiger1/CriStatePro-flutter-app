import 'package:cristatepro/admin/controllers/message_controller.dart';
import 'package:cristatepro/user/authentication/sign_in.dart';
import 'package:cristatepro/user/controllers/theme_controller.dart';
import 'package:cristatepro/user/fragments/more/aboutus.dart';
import 'package:cristatepro/user/fragments/more/notification_page.dart';
import 'package:cristatepro/user/fragments/more/pricing.dart';
import 'package:cristatepro/user/fragments/more/privacypolicy.dart';
import 'package:cristatepro/user/fragments/profile_fragment_screen.dart';
import 'package:cristatepro/user/fragments/more/setting.dart';
import 'package:cristatepro/user/fragments/more/termsandconditions.dart';
import 'package:cristatepro/user/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreFragmentScreen extends StatelessWidget {
  MoreFragmentScreen({super.key});
  final MessageController messageController = Get.find();

  signOutUser() async {
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey,
        title: const Text(
          "Sign Out",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: const Text("Are you sure you want to Sign out?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
              onPressed: () {
                Get.back(result: "signout");
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
    );
    if (resultResponse == "signout") {
      messageController.clearMessages();
      RememberUserPref.removeUserInfo().then((value) {
        Get.find<ThemeController>().clearThemeSettings();
        Get.off(() => SignInScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Drawer(
        shape: InputBorder.none,
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'CrisTatePro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notification'),
                    onTap: () {
                      Get.to(() => NotificationPage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: const Text('Profile'),
                    onTap: () {
                      Get.to(() => UserProfileFragmentScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Get.to(() => const SettingsPage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.post_add),
                    title: const Text('Post'),
                    onTap: () {
                      Get.to(() => const PricingPage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About Us'),
                    onTap: () {
                      Get.to(() => const AboutUsPage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text('Terms and Conditions'),
                    onTap: () {
                      Get.to(() => const TermsAndConditionsPage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Privacy Policy'),
                    onTap: () {
                      Get.to(() => const PrivacyPolicyPage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Sign Out'),
                    onTap: () {
                      signOutUser();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
