import 'package:cristatepro/admin/fragments/houses/admin_house_list_view.dart';
import 'package:cristatepro/admin/fragments/home/home_fragment_screen.dart';
import 'package:cristatepro/user/fragments/more/more_fragment_screen.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DashboardOfAdmin extends StatelessWidget {
  final List<Widget> _fragmentScreens = [
    AdminHomeFragmentScreen(),
    AdminHouseListView(),
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
      "active_icon": FontAwesomeIcons.boxOpen,
      "non_active_icon": FontAwesomeIcons.box,
      "label": "More",
    },
  ];

  final RxInt _indexNumber = 0.obs;
  final CurrentUser currentUser = Get.put(CurrentUser());

  DashboardOfAdmin({super.key});

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
              backgroundColor: Colors.black,
              items: List.generate(3, (index) {
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
