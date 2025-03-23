import 'dart:convert';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/house/house.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class FavouriteController extends GetxController {
  final List<HouseModel> favouriteHouses = [];
  final CurrentUser _currentUser = Get.put(CurrentUser());
  final isLoading = true.obs;

  Future<void> toggleFavorite(HouseModel house) async {
    final index = favouriteHouses.indexWhere(
      (favHouse) => favHouse.houseId == house.houseId,
    );

    if (index != -1) {
      await removeFromFavorites(house);
    } else {
      await addToFavorites(house);
    }
  }

  bool isHouseFavorited(HouseModel house) {
    return favouriteHouses.any((favHouse) => favHouse.houseId == house.houseId);
  }

  Future<void> addToFavorites(HouseModel house) async {
    try {
      final Uri uri = Uri.parse(API.favouriteHouse);
      final response = await http.post(
        uri,
        body: {
          'user_id': _currentUser.user.userId.toString(),
          'house_id': house.houseId.toString(),
        },
      );
      if (response.statusCode == 200) {
        favouriteHouses.add(house);
        update();
      }
    } catch (error) {
      displayError(
          'Error adding to favourites: Check your Internet Connection');
    }
  }

  Future<void> removeFromFavorites(HouseModel house) async {
    try {
      final Uri uri = Uri.parse(API.favouriteHouse);
      final response = await http.post(
        uri,
        body: {
          'user_id': _currentUser.user.userId.toString(),
          'house_id': house.houseId.toString(),
        },
      );
      if (response.statusCode == 200) {
        favouriteHouses
            .removeWhere((favHouse) => favHouse.houseId == house.houseId);
        update();
      }
    } catch (error) {
      displayError(
          'Error removing from favourites: Check your Internet connection');
    }
  }

  Future<void> fetchFavouriteHouses() async {
    try {
      isLoading(true);
      final Uri uri = Uri.parse(API.allFavHouses);
      final response = await http.post(
        uri,
        body: {'user_id': _currentUser.user.userId.toString()},
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null &&
            jsonResponse is Map &&
            jsonResponse['success']) {
          final houseDetails = jsonResponse['favourite_houses'];
          if (houseDetails is List) {
            favouriteHouses.clear();
            favouriteHouses.addAll(
              houseDetails.map((house) => HouseModel.fromJson(house)).toList(),
            );
          } else {
            throw Exception('Invalid favourite_houses format');
          }
        } else {
          throw Exception('Favourite houses not found');
        }
      } else {
        throw Exception('Failed to fetch favourite houses');
      }
    } catch (error) {
      displayError(
          'Failed to fetch favourite houses: Check your Internet connection');
    } finally {
      isLoading(false);
    }
  }

  void displayError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}
