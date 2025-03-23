import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:cristatepro/user/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class UserProfileController extends GetxController {
  final CurrentUser _currentUser = Get.put(CurrentUser());
  final RxBool _imageUpdated = false.obs;
  final RxBool _avatarRefresh = false.obs;
  final isEditing = false.obs;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void setEditing(bool value) {
    isEditing.value = value;
  }

  bool get imageUpdated => _imageUpdated.value;
  bool get avatarRefresh => _avatarRefresh.value;

  final Uri uri = Uri.parse(API.updateUserProfile);

  Future<void> updateUserProfilePicture(BuildContext context) async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      File newImage = File(pickedImage.path);

      dio.FormData formData = dio.FormData.fromMap({
        "newImage": await dio.MultipartFile.fromFile(newImage.path,
            filename: newImage.path.split('/').last),
        "user_id": _currentUser.user.userId,
      });

      try {
        _imageUpdated.value = true;

        dio.Response response =
            await dio.Dio().post(uri.toString(), data: formData);

        if (response.data["success"]) {
          _currentUser.user.updateUserProfileImageData(
            await pickedImage.readAsBytes(),
          );

          await RememberUserPref.updateUserProfileImageData(
            await pickedImage.readAsBytes(),
          );

          Fluttertoast.showToast(
            msg: response.data["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          await Future.delayed(const Duration(seconds: 2));
        } else {
          Fluttertoast.showToast(
            msg: response.data["message"],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "An error occurred. Please try again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } finally {
        _imageUpdated.value = false;
        _avatarRefresh.value = !_avatarRefresh.value;
      }
    }
  }

  Future<void> deleteUserProfilePicture() async {
    Get.defaultDialog(
      title: "Confirmation",
      middleText: "Are you sure you want to delete your profile picture?",
      actions: [
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            Get.back();
            await deleteUserProfilePictureConfirmed();
          },
          child: const Text("Delete"),
        ),
      ],
    );
  }

  Future<void> deleteUserProfilePictureConfirmed() async {
    dio.FormData formData = dio.FormData.fromMap({
      "user_id": _currentUser.user.userId,
    });

    try {
      _imageUpdated.value = true;

      dio.Response response = await dio.Dio().post(
        API.deleteProfilePicture,
        data: formData,
      );

      if (response.data["success"]) {
        _currentUser.user.updateUserProfileImageData(null);
        await RememberUserPref.updateUserProfileImageData(null);

        Fluttertoast.showToast(
          msg: response.data["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        await Future.delayed(const Duration(seconds: 2));
      } else {
        Fluttertoast.showToast(
          msg: response.data["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      _imageUpdated.value = false;
      _avatarRefresh.value = !_avatarRefresh.value;
    }
  }

  Future<bool> updateUserInfo() async {
    bool? confirmed = await showConfirmationDialog();
    if (confirmed == null || !confirmed) return false;

    Get.dialog(
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/progressbar.json',
              width: 60,
              height: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'Saving Changes...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    try {
      final response = await http.post(
        Uri.parse(API.updateUserInfo),
        body: {
          'user_id': _currentUser.user.userId.toString(),
          'first_name': firstNameController.text.trim(),
          'last_name': lastNameController.text.trim(),
          'phone': phoneController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data != null && data['success']) {
          _currentUser.user.updateUserInfoData(
              firstNameController.text.trim(),
              lastNameController.text.trim(),
              int.parse(phoneController.text.trim()));

          await RememberUserPref.updateUserInfo(
              firstNameController.text.trim(),
              lastNameController.text.trim(),
              int.parse(phoneController.text.trim()));
          Fluttertoast.showToast(
            msg: 'User info updated successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return true;
        } else {
          Fluttertoast.showToast(
            msg: 'Error updating user profile',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          return false;
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Error: ${response.reasonPhrase}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failled to update user info, check your internet connection.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    } finally {
      Get.back();
    }
  }

  Future<bool?> showConfirmationDialog() async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Confirmation"),
        content: const Text("Do you want to update user info?"),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Get.back(result: false);
            },
          ),
          TextButton(
            child: const Text("Update"),
            onPressed: () {
              Get.back(result: true);
            },
          ),
        ],
      ),
    );
  }
}
