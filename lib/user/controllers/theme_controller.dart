import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;
  RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
    _loadIndexFromPrefs();
  }

  Future<void> _loadIndexFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedIndex.value = prefs.getInt('selectedIndex') ?? 0;
  }

  Future<void> _loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void _saveThemeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode.value);
  }

  void _saveIndexToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedIndex', selectedIndex.value);
  }

  void toggleTheme(bool isDark) {
    isDarkMode.value = isDark;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToPrefs();
  }

  void setIndex(int index) {
    selectedIndex.value = index;
    _saveIndexToPrefs();
  }

  void clearThemeSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isDarkMode');
    prefs.remove('selectedIndex');
    Get.changeThemeMode(ThemeMode.light);
    isDarkMode.value = false;
    selectedIndex.value = 0;
  }
}
