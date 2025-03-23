import 'package:cristatepro/user/controllers/theme_controller.dart';
import 'package:cristatepro/widgets/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slide_switcher/slide_switcher.dart';

class ThemePage extends StatelessWidget {
  final ThemeController _themeController = Get.find<ThemeController>();

  ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(
          title: "Theme Settings",
          centerTitle: true,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Toggle Dark Mode',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Obx(() => SlideSwitcher(
                  key: const PageStorageKey<String>("toggleDarkMode"),
                  initialIndex: _themeController.selectedIndex.value,
                  onSelect: (index) {
                    _themeController.toggleTheme(index == 1);
                    _themeController.setIndex(index);
                  },
                  containerHeight: 40,
                  containerWight: 90,
                  children: const [
                    Icon(Icons.wb_sunny, color: Colors.amber),
                    Icon(Icons.nightlight_round, color: Colors.blue),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
