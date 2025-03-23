import 'dart:convert';
import 'dart:async';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/user/authentication/sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class PasswordResetController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var email = ''.obs;
  var firstName = ''.obs;
  var lastName = ''.obs;
  var maskedPhone = ''.obs;
  var completePhone = ''.obs;
  var phoneNumberInput = ''.obs;
  var newPassword = ''.obs;
  var confirmPassword = ''.obs();
  var isEmailChecked = false.obs;
  var completionPercentage = 0.0.obs;
  var isObscure = true.obs;
  var countdown = 15.obs;

  Timer? _timer;

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

  Future<void> checkEmail() async {
    if (emailController.text.trim().isEmpty) {
      showToast('Please enter your email.', false);
      return;
    }

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Checking email...',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/progressbar.json',
                width: 60,
                height: 60,
              ),
              const SizedBox(height: 20),
              const Text('Please wait...'),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );

    const url = API.checkEmail;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'email': emailController.text.trim()},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          firstName.value = data['firstname'];
          lastName.value = data['lastname'];
          completePhone.value = data['phone'];
          maskedPhone.value = maskPhoneNumber(data['phone']);
          isEmailChecked.value = true;
          completionPercentage.value = 0.33;
          showToast('Email verified successfully!', true);
        } else {
          showToast('Error: ${data['message']}', false);
        }
      } else {
        showToast('Failed to check email. Please try again.', false);
      }
    } catch (e) {
      if (kDebugMode) print('Error: $e');
      showToast('An error occurred: $e', false);
    } finally {
      Get.back();
    }
  }

  String maskPhoneNumber(String phone) {
    return phone.replaceRange(4, 8, '####');
  }

  bool checkPhoneNumberInput() {
    return completePhone.value == phoneNumberController.text.trim();
  }

  Future<void> resetPassword() async {
    if (newPassword.value != confirmPassword) {
      showToast('Passwords do not match.', false);
      return;
    } else if (newPassword.value.length < 8) {
      showToast('Password must be at least 8 characters long.', false);
      return;
    }

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Resetting password...',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/progressbar.json',
                width: 60,
                height: 60,
              ),
              const SizedBox(height: 20),
              const Text('Please wait...'),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );

    const url = API.resetPassword;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': emailController.text.trim(),
          'new_password': newPassword.value,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          showToast('Password reset successful!', true);
          completionPercentage.value = 1.0;
          _startCountdown();
        } else {
          showToast('Error: ${data['message']}', false);
        }
      } else {
        showToast('Failed to reset password. Please try again.', false);
      }
    } catch (e) {
      if (kDebugMode) print('Error: $e');
      showToast('An error occurred: $e', false);
    } finally {
      Get.back();
    }
  }

  void _startCountdown() {
    countdown.value = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        _timer?.cancel();
        Get.offAll(() => SignInScreen());
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
