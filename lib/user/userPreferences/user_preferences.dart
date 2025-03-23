import 'dart:convert';
import 'dart:typed_data';

import 'package:cristatepro/user/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPref {
  static Future<void> storeUserInfo(User userinfo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userjsonData = jsonEncode(userinfo.toJson());
    await preferences.setString("currentUser", userjsonData);
  }

  static Future<User?> readUserInfo() async {
    User? currentUserInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString("currentUser");
    if (userInfo != null) {
      Map<String, dynamic> userDatamap = jsonDecode(userInfo);
      currentUserInfo = User.fromJson(userDatamap);
    }
    return currentUserInfo;
  }

  static Future<void> removeUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentUser");
  }

  static Future<void> updateUserProfileImageData(
      Uint8List? newImageData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString("currentUser");

    if (userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      User currentUserInfo = User.fromJson(userDataMap);

      currentUserInfo.updateUserProfileImageData(newImageData);

      String updatedUserInfo = jsonEncode(currentUserInfo.toJson());
      await preferences.setString("currentUser", updatedUserInfo);
    }
  }

  static Future<void> updateUserInfo(
      String? firstName, String? lastName, int? phone) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString("currentUser");

    if (userInfo != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      User currentUserInfo = User.fromJson(userDataMap);

      currentUserInfo.userFirstName = firstName!;
      currentUserInfo.userLastName = lastName!;
      currentUserInfo.userNumber = phone!;

      String updatedUserInfo = jsonEncode(currentUserInfo.toJson());
      await preferences.setString("currentUser", updatedUserInfo);
    }
  }
}
