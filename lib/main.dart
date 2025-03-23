import 'package:cristatepro/admin/controllers/admin_house_controller.dart';
import 'package:cristatepro/admin/controllers/message_controller.dart';
import 'package:cristatepro/configs/constants.dart';
import 'package:cristatepro/user/controllers/houses_controller.dart';
import 'package:cristatepro/user/controllers/theme_controller.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:cristatepro/util/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

AppTheme _appTheme = AppTheme();

main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(CurrentUser());
  Get.put(AdminHouseController());
  Get.put(UserHouseController());
  Get.put(MessageController());

  AwesomeNotifications().initialize(
    'resource://drawable/res_icon',
    [
      NotificationChannel(
        channelKey: 'house_channel',
        channelName: 'House Channel',
        channelDescription: 'Channel for house-related notifications',
        importance: NotificationImportance.High,
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        enableLights: true,
        enableVibration: true,
        soundSource: 'resource://raw/res_among',
      ),
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Schedule Channel',
        channelDescription: 'Channel for set weekly scheduled notifications',
        importance: NotificationImportance.High,
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        enableLights: true,
        enableVibration: true,
        soundSource: 'resource://raw/res_skadoosh',
      ),
      NotificationChannel(
        channelKey: 'message_channel',
        channelName: 'Message Channel',
        channelDescription: 'Channel for message notifications',
        importance: NotificationImportance.High,
        defaultColor: const Color(0xFF4CAF50),
        ledColor: Colors.green,
        enableLights: true,
        enableVibration: true,
        soundSource: 'resource://raw/res_duck',
      ),
      NotificationChannel(
        channelKey: 'reminder_channel',
        channelName: 'Reminder Channel',
        channelDescription: 'Channel for reminder notifications',
        importance: NotificationImportance.High,
        defaultColor: const Color(0xFFFFC107),
        ledColor: Colors.amber,
        enableLights: true,
        enableVibration: true,
        soundSource: 'resource://raw/res_skadoosh',
      ),
    ],
    debug: true,
  );

  ThemeController themeController = Get.put(ThemeController());

  runApp(
    GetBuilder<ThemeController>(
      builder: (_) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: "/",
          getPages: Routes.routes,
          theme: _appTheme.lightTheme,
          darkTheme: _appTheme.darkTheme,
          themeMode: themeController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
        );
      },
    ),
  );
}
