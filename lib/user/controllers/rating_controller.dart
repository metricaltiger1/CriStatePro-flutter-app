import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/user/controllers/houses_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RatingController extends GetxController {
  RxDouble userRating = 0.0.obs;
  final UserHouseController houseController = Get.find();

  void setUserRating(double rating) {
    userRating.value = rating;
  }

  Future<void> sendRating(double rating, int houseId, int userId) async {
    const url = API.houseRating;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'rating': rating.toString(),
          'house_id': houseId.toString(),
          'user_id': userId.toString(),
        },
      );

      if (response.statusCode == 200) {
        houseController.fetchUserHouses();
        Get.snackbar(
          'Success',
          'Rating sent successfully!',
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to send rating',
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error sending rating, check your internet connection',
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
