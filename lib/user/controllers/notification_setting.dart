import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsController extends GetxController {
  var receiveNotifications = true.obs;
  var vibrateOnNotification = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void toggleReceiveNotifications(bool value) {
    receiveNotifications.value = value;
    _saveSettings();
  }

  void toggleVibrateOnNotification(bool value) {
    vibrateOnNotification.value = value;
    _saveSettings();
  }

  void deleteSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('receiveNotifications');
    await prefs.remove('vibrateOnNotification');
    receiveNotifications.value = true;
    vibrateOnNotification.value = true;
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    receiveNotifications.value = prefs.getBool('receiveNotifications') ?? true;
    vibrateOnNotification.value =
        prefs.getBool('vibrateOnNotification') ?? true;
  }

  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('receiveNotifications', receiveNotifications.value);
    prefs.setBool('vibrateOnNotification', vibrateOnNotification.value);
  }
}
