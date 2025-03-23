import 'dart:convert';
import 'package:cristatepro/admin/fragments/dashboard.dart';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/user/fragments/dashboard.dart';
import 'package:cristatepro/user/model/user.dart';
import 'package:cristatepro/user/userPreferences/user_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isObscure = true.obs;

  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(color: Colors.white60),
  );

  signinUserNow(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Logging in...',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Lottie.asset(
                'assets/progressbar.json',
                width: 60,
                height: 60,
              ),
              const SizedBox(height: 20),
              const Text(
                'Please wait...',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        );
      },
    );

    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      showToast('Please enter email and password', false);
      Navigator.pop(context);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(API.signInUser),
        body: {
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success']) {
          showToast('Login successful', true);

          if (data['userData'] != null &&
              data['userData'] is Map<String, dynamic>) {
            User userInfo = User.fromJson(data['userData']);

            if (userInfo.userProfileImageData != null) {
              await RememberUserPref.storeUserInfo(userInfo);
            } else {
              showToast('Invalid user data received', false);
            }

            if (userInfo.userRole == 1) {
              Get.offAll(() => DashboardOfAdmin());
            } else {
              Get.offAll(() => DashboardOfFragments());
            }
          } else {
            showToast('Invalid user data received', false);
          }
        } else {
          showToast('Login failed: ${data['message']}', false);
        }
      } else {
        showToast('Error connecting to the server', false);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      showToast('Failed to sign in, check your internet connection.', false);
    } finally {
      Get.back();
    }
  }

  void showToast(String message, bool success) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: success ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
