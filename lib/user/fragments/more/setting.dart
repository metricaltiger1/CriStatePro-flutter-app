import 'package:cristatepro/settings/aboutapp.dart';
import 'package:cristatepro/settings/feedback.dart';
import 'package:cristatepro/settings/helpandsupport.dart';
import 'package:cristatepro/settings/notificationsetting.dart';
import 'package:cristatepro/settings/theme.dart';
import 'package:cristatepro/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(
          title: "Settings",
          centerTitle: false,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Theme Settings'),
              onTap: () {
                Get.to(() => ThemePage());
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Settings'),
              onTap: () {
                Get.to(() => NotificationSettingsPage());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About App'),
              onTap: () {
                Get.to(() => const AboutApp());
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () {
                Get.to(() => const HelpAndSupport());
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Feedback'),
              onTap: () {
                Get.to(() => FeedbackPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
