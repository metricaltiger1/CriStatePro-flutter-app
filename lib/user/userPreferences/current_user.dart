import 'package:cristatepro/user/model/user.dart';
import 'package:cristatepro/user/userPreferences/user_preferences.dart';
import 'package:get/get.dart';

class CurrentUser extends GetxController {
  final Rx<User> _currentUser = User(0, '', '', 0, '', '', null, '', 0).obs;
  User get user => _currentUser.value;

  getUserInfo() async {
    User? getUserInfoFromLocalStorage = await RememberUserPref.readUserInfo();
    _currentUser.value =
        getUserInfoFromLocalStorage ?? User(0, '', '', 0, '', '', null, '', 0);
  }
}
