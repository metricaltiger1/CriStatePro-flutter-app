import 'dart:convert';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class FeedbackController extends GetxController {
  final _isSubmitting = false.obs;
  final CurrentUser _currentUser = Get.put(CurrentUser());
  final TextEditingController feedbackTextController = TextEditingController();

  bool get isSubmitting => _isSubmitting.value;

  Future<void> submitFeedback(String feedback) async {
    if (_isSubmitting.value) {
      return;
    }

    try {
      _isSubmitting.value = true;

      Get.dialog(
        AlertDialog(
          content: Row(
            children: [
              Lottie.asset(
                'assets/progressbar.json',
                width: 60,
                height: 60,
              ),
              const SizedBox(width: 16),
              const Text('Submitting feedback...'),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      final Uri uri = Uri.parse(API.sendUserFeedback);
      final response = await http.post(
        uri,
        body: {
          'user_id': _currentUser.user.userId.toString(),
          'feedback': feedbackTextController.text,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success']) {
          showToast('Feedback submitted successfully', true);
          feedbackTextController.clear();
          Get.back();
        } else {
          showToast('Failed to submit feedback: ${data['message']}', false);
          Get.back();
        }
      } else {
        showToast('Error connecting to the server', false);
        Get.back();
      }
    } catch (e) {
      showToast(
          'Failed to submit feedback. Check your internet connection', false);
      Get.back();
    } finally {
      _isSubmitting.value = false;
    }
  }

  void showToast(String message, bool isSuccess) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: isSuccess ? Colors.green : Colors.red,
    );
  }
}
