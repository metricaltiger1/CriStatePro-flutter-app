import 'package:cristatepro/admin/controllers/admin_house_controller.dart';
import 'package:cristatepro/admin/fragments/dashboard.dart';
import 'package:cristatepro/services/notification.dart';
import 'package:cristatepro/user/authentication/sign_in.dart';
import 'package:cristatepro/user/fragments/dashboard.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:cristatepro/user/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final NotificationManager notificationManager = NotificationManager();

  @override
  Widget build(BuildContext context) {
    notificationManager.requestNotificationPermissions();
    notificationManager.initializeNotifications();

    const int splashDuration = 3;
    Get.put(CurrentUser());
    Get.put(AdminHouseController());

    Future.delayed(const Duration(seconds: splashDuration), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

      if (isFirstLaunch) {
        Get.offNamed('/onboarding');
      } else {
        RememberUserPref.readUserInfo().then((user) async {
          if (user == null) {
            Get.off(() => SignInScreen());
          } else {
            if (user.userRole.toString() == '1') {
              Get.off(() => DashboardOfAdmin());
            } else {
              Get.off(() => DashboardOfFragments());
            }
          }
        });
      }
    });

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/splash_screen.json',
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 20,
              ),
              const AnimatedDefaultTextStyle(
                duration: Duration(seconds: 1),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                curve: Curves.easeInOut,
                child: Text(
                  'CrisTatePro',
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                'Unleashing real estate brilliance!!!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
