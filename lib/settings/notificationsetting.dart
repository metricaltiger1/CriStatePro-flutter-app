import 'package:cristatepro/user/controllers/notification_setting.dart';
import 'package:cristatepro/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSettingsPage extends StatelessWidget {
  final NotificationSettingsController _controller =
      Get.put(NotificationSettingsController());

  NotificationSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(
          title: 'Notification Settings',
          centerTitle: true,
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Row(
                    children: [
                      const Text(
                        'Receive Notifications:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Switch(
                        value: _controller.receiveNotifications.value,
                        onChanged: _controller.toggleReceiveNotifications,
                      ),
                    ],
                  )),
              const SizedBox(height: 16),
              Obx(() => Row(
                    children: [
                      const Text(
                        'Vibrate on Notification:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Switch(
                        value: _controller.vibrateOnNotification.value,
                        onChanged: _controller.toggleVibrateOnNotification,
                      ),
                    ],
                  )),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Notification settings saved successfully!'),
                    ),
                  );
                },
                child: const Text('Save Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
