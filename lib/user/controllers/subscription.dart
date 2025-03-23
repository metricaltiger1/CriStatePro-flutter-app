import 'dart:convert';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class SubscriptionController extends GetxController {
  RxInt subscriptionRemaining = RxInt(0);

  Future<void> fetchSubscriptionRemaining(int userId) async {
    final url = '${API.getSubscription}?user_id=$userId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
        final subscriptionRemainingValue =
            responseData['subscription_remaining'];
        if (subscriptionRemainingValue is String) {
          final parsedSubscriptionRemaining =
              int.tryParse(subscriptionRemainingValue);
          if (parsedSubscriptionRemaining != null) {
            subscriptionRemaining.value = parsedSubscriptionRemaining;
            Get.snackbar(
                'Success', 'Subscription remaining updated successfully.');
          } else {
            Get.snackbar(
                'Error', 'Failed to parse subscription remaining value.');
          }
        } else {
          Get.snackbar(
              'Error', 'Subscription remaining is not in the expected format.');
        }
      } else {
        final errorMessage = responseData['message'];
        Get.snackbar('Error', errorMessage);
      }
    } else {
      final errorReason = response.reasonPhrase;
      Get.snackbar(
          'Error', 'Failed to fetch subscription remaining: $errorReason');
    }
  }

  Future<void> decrementSubscriptionRemaining(int userId) async {
    final url = '${API.decrementSubscription}?user_id=$userId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
      } else {}
    } else {}
  }

  void updateSubscription(int userId, int subscriptionRemaining) async {
    Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Processing your request',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Lottie.asset(
                'assets/progressbar.json',
                width: 60,
                height: 60,
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
    final url =
        '${API.subscription}?user_id=$userId&subscription_remaining=$subscriptionRemaining';
    final response = await http.get(
      Uri.parse(url),
    );

    Get.back();

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success']) {
        Get.snackbar('Success', 'Subscription updated successfully.');
      } else {
        if (responseData['message'] == 'Free tier is already used.') {
          Get.snackbar('Subscription Failed!', 'Free tier is already used.');
        } else {
          final errorMessage = 'Error: ${responseData['message']}';
          Get.snackbar('Error', errorMessage);
        }
      }
    } else {
      final errorMessage =
          'Failed to update subscription. Error: ${response.reasonPhrase}';
      Get.snackbar('Error', errorMessage);
    }
  }
}
