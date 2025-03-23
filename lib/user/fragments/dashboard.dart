import 'package:cristatepro/user/fragments/favourites/favourite_fragment_screen.dart';
import 'package:cristatepro/user/fragments/home/home_fragment_screen.dart';
import 'package:cristatepro/user/fragments/house_videos/videos.dart';
import 'package:cristatepro/user/fragments/houses/house_list_fragment_screen.dart';
import 'package:cristatepro/user/fragments/more/more_fragment_screen.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DashboardOfFragments extends StatelessWidget {
  final List<Widget> _fragmentScreens = [
    HomeFragmentScreen(),
    UserHouseListView(),
    const HouseVideoPage(),
    const FavouriteFragmentScreen(),
    MoreFragmentScreen(),
  ];

  final List _navigationButtonProperties = [
    {
      "active_icon": Icons.home,
      "non_active_icon": Icons.home_outlined,
      "label": "Home",
    },
    {
      "active_icon": Icons.house,
      "non_active_icon": Icons.house_outlined,
      "label": "Houses",
    },
    {
      "active_icon": Icons.video_library,
      "non_active_icon": Icons.video_library_outlined,
      "label": "Videos",
    },
    {
      "active_icon": Icons.favorite,
      "non_active_icon": Icons.favorite_border,
      "label": "Favourite",
    },
    {
      "active_icon": FontAwesomeIcons.boxOpen,
      "non_active_icon": FontAwesomeIcons.box,
      "label": "More",
    },
  ];

  final RxInt _indexNumber = 0.obs;
  final CurrentUser currentUser = Get.put(CurrentUser());

  DashboardOfFragments({super.key});

  @override
  Widget build(BuildContext context) {
    currentUser.getUserInfo();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (_indexNumber.value > 0) {
          _indexNumber.value--;
          return Future.value();
        } else {
          return Future.value();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Obx(
            () => _fragmentScreens[_indexNumber.value],
          ),
        ),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
              currentIndex: _indexNumber.value,
              onTap: (value) {
                _indexNumber.value = value;
              },
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white60,
              items: List.generate(5, (index) {
                var navBtnProperty = _navigationButtonProperties[index];
                return BottomNavigationBarItem(
                  backgroundColor: Colors.black,
                  icon: Icon(navBtnProperty["non_active_icon"]),
                  activeIcon: Icon(navBtnProperty["active_icon"]),
                  label: navBtnProperty["label"],
                );
              }),
            )),
      ),
    );
  }
}
