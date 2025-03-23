import 'package:cristatepro/services/notification.dart';
import 'package:cristatepro/user/fragments/home/recent.dart';
import 'package:cristatepro/widgets/customtext.dart';
import 'package:cristatepro/widgets/message_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cristatepro/admin/controllers/message_controller.dart';
import 'package:cristatepro/user/controllers/houses_controller.dart';
import 'package:cristatepro/user/fragments/home/air_bnb.dart';
import 'package:cristatepro/user/fragments/home/offices.dart';
import 'package:cristatepro/user/fragments/home/popular_houses.dart';
import 'package:cristatepro/widgets/category.dart';
import 'package:cristatepro/user/controllers/home_controller.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';

class HomeFragmentScreen extends StatelessWidget {
  final HomeScreenController _homeScreenController =
      Get.put(HomeScreenController());

  final CurrentUser _currentUser = Get.find<CurrentUser>();
  final UserHouseController _houseController = Get.put(UserHouseController());
  final MessageController _messageController = Get.put(MessageController());

  HomeFragmentScreen({super.key});

  final ScrollController _scrollController = ScrollController();

  final GlobalKey _popularKey = GlobalKey();
  final GlobalKey _recentKey = GlobalKey();
  final GlobalKey _officeKey = GlobalKey();
  final GlobalKey _airBnbKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final BuildContext? context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    _houseController.fetchUserHouses();
    _messageController.fetchMessages(_currentUser.user.userId.toString());
    String userFirstName = _currentUser.user.userFirstName.toString();
    if (userFirstName.isNotEmpty) {
      NotificationManager().scheduleWeeklyNotifications(userFirstName);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child:
                        _homeScreenController.buildProfileImage(_currentUser),
                  ),
                  const SizedBox(height: 8, width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        final userName = _currentUser.user.userFirstName;
                        final greeting = _homeScreenController.getGreeting();
                        return Text(
                          '$greeting, $userName!',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        );
                      }),
                      const SizedBox(height: 8),
                      const Text(
                        "Find your dream home",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  MessageIconButton()
                ],
              ),
              const SizedBox(height: 8),
              const CustomText(
                label: 'Categories',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                lableColor: Colors.blue,
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CategoryItem(
                      text: "Top Rated",
                      icon: Icons.star,
                      onTap: () => _scrollToSection(_popularKey),
                    ),
                    const SizedBox(width: 4),
                    CategoryItem(
                      text: "Recent",
                      icon: Icons.new_releases,
                      onTap: () => _scrollToSection(_recentKey),
                    ),
                    const SizedBox(width: 4),
                    CategoryItem(
                      text: "Office",
                      icon: Icons.business,
                      onTap: () => _scrollToSection(_officeKey),
                    ),
                    const SizedBox(width: 4),
                    CategoryItem(
                      text: "Air BNB",
                      icon: Icons.hotel,
                      onTap: () => _scrollToSection(_airBnbKey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Container(
                key: _popularKey,
                child: PopularHousesCarousel(houses: _houseController.houses),
              ),
              const SizedBox(height: 10),
              Container(
                key: _airBnbKey,
                child: AirBnBListings(houses: _houseController.houses),
              ),
              const SizedBox(height: 10),
              Container(
                key: _officeKey,
                child: Offices(houses: _houseController.houses),
              ),
              const SizedBox(height: 10),
              Container(
                key: _recentKey,
                child: RecentItem(houses: _houseController.houses),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
