import 'package:cristatepro/admin/controllers/admin_house_controller.dart';
import 'package:cristatepro/admin/controllers/home_controller.dart';
import 'package:cristatepro/admin/controllers/message_controller.dart';
import 'package:cristatepro/admin/fragments/message_list_screen.dart';
import 'package:cristatepro/services/notification.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cristatepro/admin/fragments/home/add_house_view.dart';
import 'package:cristatepro/configs/constants.dart';

class AdminHomeFragmentScreen extends StatelessWidget {
  final AdminHomeController adminHomeController =
      Get.put(AdminHomeController());
  final AdminHouseController houseController = Get.find();
  final CurrentUser currentUser = Get.put(CurrentUser());
  final MessageController messageController = Get.put(MessageController());
  final NotificationManager notificationManager = NotificationManager();

  AdminHomeFragmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    houseController.fetchAdminHouses();
    messageController.fetchMessages(currentUser.user.userId.toString());
    String userFirstName = currentUser.user.userFirstName.toString();
    if (userFirstName.isNotEmpty) {
      NotificationManager().scheduleWeeklyNotifications(userFirstName);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("CrisTatePro Admin Panel"),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: adminHomeController
                        .buildProfileImage(adminHomeController.currentUser),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Obx(() {
                        final userName =
                            adminHomeController.currentUser.user.userFirstName;
                        final greeting = adminHomeController.greeting;
                        return GestureDetector(
                          onTap: () {},
                          child: Text(
                            '$greeting, $userName!',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      Text(
                        'Welcome to Admin Panel',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    iconSize: 30,
                    color: Colors.blue,
                    splashColor: Colors.amber,
                    onPressed: () {
                      Get.to(() => MessageListPage());
                    },
                    icon: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Image.asset(
                        'assets/messages.png',
                        width: 40.0,
                        height: 40.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Get.to(() => AddHouseView());
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: appWhiteColor,
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('Add a New House'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  notificationManager.newHouseNotifications();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: appWhiteColor,
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications),
                    SizedBox(width: 8),
                    Text('Trigger Notification'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
