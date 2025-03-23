import 'dart:convert';

import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/house/house.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AdminHouseController extends GetxController {
  final houses = [].obs;
  final isLoading = true.obs;

  final TextEditingController searchController = TextEditingController();
  final isSearching = false.obs;
  final Uri uri = Uri.parse(API.houseDeletion);
  final filteredHouses = [].obs;
  final CurrentUser _currentUser = Get.find();

  final Map<String, bool> _deletingMap = {};

  bool isDeleting(String houseId) {
    return _deletingMap[houseId] ?? false;
  }

  void setDeleting(String houseId, bool value) {
    _deletingMap[houseId] = value;
    update();
  }

  Future<void> fetchAdminHouses() async {
    try {
      final Uri uri = Uri.parse(API.curentAdminHouses);
      final response = await http.post(
        uri,
        body: {'id': _currentUser.user.userId.toString()},
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          final housesData = jsonResponse['houses'];
          houses.assignAll(
              housesData.map((json) => HouseModel.fromJson(json)).toList());

          if (houses.isEmpty) {
            displayError('No houses found for this admin');
          } else {
            Fluttertoast.showToast(
              msg: 'Admin houses fetched successfully',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
          }
        } else {
          displayError(
              'Failed to fetch admin houses: ${jsonResponse['message']}');
        }
      } else {
        displayError('Admin houses not found');
      }
    } catch (error) {
      displayError('Error fetching admin houses');
    } finally {
      isLoading(false);
    }
  }

  void filterHouses(String query) {
    if (query.isEmpty) {
      filteredHouses.assignAll(houses);
    } else {
      final filteredList = houses
          .where((house) =>
              house.houseTitle.toLowerCase().contains(query.toLowerCase()) ||
              house.houseDescription
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
      filteredHouses.assignAll(filteredList);
    }
  }

  void cancelSearch() {
    searchController.clear();
    isSearching(false);
  }

  int housesCreated() {
    return houses.length;
  }

  Future<void> deleteAdminHouse(String houseId) async {
    try {
      setDeleting(houseId, true);
      final response = await http.post(
        uri,
        body: {'house_id': houseId},
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          houses.removeWhere((house) => house.houseId.toString() == houseId);
          filteredHouses
              .removeWhere((house) => house.houseId.toString() == houseId);
          Fluttertoast.showToast(
            msg: jsonResponse['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          displayError('Failed to delete house: ${jsonResponse['message']}');
        }
      } else {
        displayError('Failed to delete house');
      }
    } catch (error) {
      displayError('Error deleting house');
    } finally {
      await Future.delayed(const Duration(milliseconds: 500));
      setDeleting(houseId, false);
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
