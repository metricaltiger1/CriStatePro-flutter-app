import 'dart:convert';
import 'package:cristatepro/admin/controllers/add_house.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cristatepro/admin/controllers/admin_house_controller.dart';
import 'package:cristatepro/house/house.dart';
import 'package:cristatepro/api_connection/api_connection.dart';

class UserHouseController extends GetxController {
  final houses = <HouseModel>[].obs;
  final isLoading = true.obs;
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchCountyController = TextEditingController();
  final TextEditingController searchTypeController = TextEditingController();
  final TextEditingController searchAmenityController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final isSearching = false.obs;
  final filteredHouses = <HouseModel>[].obs;
  int currentPage = 1;
  bool isFetching = false;
  final AdminHouseController adminHomeController = Get.find();

  var selectedCounty = <String>[].obs;
  var minPrice = ''.obs;
  var maxPrice = ''.obs;
  var selectedBedrooms = <int>[].obs;
  var selectedBathrooms = <int>[].obs;
  var selectedPropertyType = <String>[].obs;
  var selectedAmenity = <String>[].obs;
  var expandedFilter = ''.obs;
  var filtersApplied = false.obs;
  var showFilters = false.obs;
  var searchCountyQuery = ''.obs;
  var searchTypeQuery = ''.obs;
  var searchAmenityQuery = ''.obs;

  @override
  void onInit() {
    fetchUserHouses();
    allCounties.sort();
    super.onInit();
  }

  void searchHouses() {
    if (searchController.text.isEmpty) {
      filteredHouses.assignAll(houses);
    } else {
      final filteredList = houses
          .where((house) =>
              house.houseTitle
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()) ||
              house.houseDescription
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()) ||
              house.houseLocation
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()) ||
              house.houseType
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()) ||
              house.housePrice
                  .toString()
                  .contains(searchController.text.toLowerCase()))
          .toList();
      filteredHouses.assignAll(filteredList);
    }
  }

  void cancelSearch() {
    searchController.clear();
    isSearching(false);
  }

  Future<void> fetchUserHouses({int pageSize = 25}) async {
    try {
      if (isFetching) return;
      isFetching = true;
      isLoading(true);
      final Uri uri =
          Uri.parse('${API.allHouses}?page=$currentPage&pageSize=$pageSize');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          final housesList = jsonResponse['houses'] as List<dynamic>;

          houses.addAll(
            housesList
                .map(
                    (json) => HouseModel.fromJson(json as Map<String, dynamic>))
                .toList(),
          );

          currentPage++;
        } else {
          Fluttertoast.showToast(
            msg: 'Failed to fetch houses: ${jsonResponse['message']}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to fetch houses: ${response.statusCode}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Failed to fetch houses, check your internet connection',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      isFetching = false;
      isLoading(false);
    }
  }

  HouseModel fetchPropertiesByHouseId(int houseId) {
    final house = adminHomeController.houses.isNotEmpty
        ? adminHomeController.houses
            .firstWhere((house) => house.houseId == houseId,
                orElse: () => HouseModel(
                      0,
                      0,
                      'Unavailable',
                      'Unavailable',
                      '',
                      '',
                      '',
                      '',
                      '',
                      '',
                      '',
                      '',
                      0.0,
                      '',
                      '',
                      '',
                      [],
                      0.0,
                      0,
                      '',
                      '',
                    ))
        : houses.firstWhere((house) => house.houseId == houseId,
            orElse: () => HouseModel(
                  0,
                  0,
                  'Unavailable',
                  'Unavailable',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  0.0,
                  '',
                  '',
                  '',
                  [],
                  0.0,
                  0,
                  '',
                  '',
                ));

    return house;
  }

  void randomizeHouses() {
    List<HouseModel> shuffledHouses = List.from(houses);
    shuffledHouses.shuffle();
    houses.assignAll(shuffledHouses);
  }

  void toggleCounty(String county) {
    if (selectedCounty.contains(county)) {
      selectedCounty.remove(county);
    } else {
      selectedCounty.add(county);
    }
    updateFiltersApplied();
  }

  void setMinPrice(String price) {
    minPrice.value = price;
    minPriceController.text = price;

    updateFiltersApplied();
  }

  void setMaxPrice(String price) {
    maxPrice.value = price;
    maxPriceController.text = price;

    updateFiltersApplied();
  }

  void toggleBedrooms(int bedrooms) {
    if (selectedBedrooms.contains(bedrooms)) {
      selectedBedrooms.remove(bedrooms);
    } else {
      selectedBedrooms.add(bedrooms);
    }
    updateFiltersApplied();
  }

  void toggleBathrooms(int bathrooms) {
    if (selectedBathrooms.contains(bathrooms)) {
      selectedBathrooms.remove(bathrooms);
    } else {
      selectedBathrooms.add(bathrooms);
    }
    updateFiltersApplied();
  }

  void togglePropertyType(String type) {
    if (selectedPropertyType.contains(type)) {
      selectedPropertyType.remove(type);
    } else {
      selectedPropertyType.add(type);
    }
    updateFiltersApplied();
  }

  void toggleAmenity(String amenity) {
    if (selectedAmenity.contains(amenity)) {
      selectedAmenity.remove(amenity);
    } else {
      selectedAmenity.add(amenity);
    }
    updateFiltersApplied();
  }

  void toggleFilter(String filterName) {
    if (expandedFilter.value == filterName) {
      expandedFilter.value = '';
    } else {
      expandedFilter.value = filterName;
    }
  }

  List<HouseModel> filterHouses(List<HouseModel> houses) {
    return houses.where((house) {
      final matchesCounty = selectedCounty.isEmpty ||
          selectedCounty.any((county) =>
              house.houseLocation.toLowerCase().contains(county.toLowerCase()));
      final matchesPrice = (minPrice.isEmpty ||
              double.parse(house.housePrice.toString()) >=
                  double.parse(minPrice.value)) &&
          (maxPrice.isEmpty ||
              double.parse(house.housePrice.toString()) <=
                  double.parse(maxPrice.value));
      final matchesBedrooms = selectedBedrooms.isEmpty ||
          selectedBedrooms.contains(int.parse(house.houseBedrooms));
      final matchesBathrooms = selectedBathrooms.isEmpty ||
          selectedBathrooms.contains(int.parse(house.houseBathrooms));
      final matchesPropertyType = selectedPropertyType.isEmpty ||
          selectedPropertyType.contains(house.houseType);
      final matchesAmenity = selectedAmenity.isEmpty ||
          selectedAmenity.any((amenity) => house.houseAmenities
              .toLowerCase()
              .contains(amenity.toLowerCase()));

      return matchesCounty &&
          matchesPrice &&
          matchesBedrooms &&
          matchesBathrooms &&
          matchesPropertyType &&
          matchesAmenity;
    }).toList();
  }

  void applyFilters() {
    filteredHouses.assignAll(filterHouses(houses));
    filtersApplied.value = true;
    showFilters.value = true;
    update();
  }

  void clearMinPrice() {
    minPrice.value = '';
    minPriceController.clear();
  }

  void clearMaxPrice() {
    maxPrice.value = '';
    maxPriceController.clear();
  }

  void clearFilters() {
    selectedCounty.clear();
    searchCountyController.clear();
    searchTypeController.clear();
    searchAmenityController.clear();
    clearMaxPrice();
    clearMinPrice();
    clearAmenitySearchQuery();
    clearCountySearchQuery();
    clearTypeSearchQuery();
    selectedBedrooms.clear();
    selectedBathrooms.clear();
    selectedPropertyType.clear();
    selectedAmenity.clear();
    filteredHouses.assignAll(houses);
    filtersApplied.value = false;
    showFilters.value = false;
    searchCountyQuery.value = '';
    searchAmenityQuery.value = '';
    searchTypeQuery.value = '';

    update();
  }

  List<String> allCounties = [
    'Baringo',
    'Bomet',
    'Bungoma',
    'Busia',
    'Elgeyo- Marakwet',
    'Embu',
    'Garissa',
    'Homabay',
    'Isiolo',
    'Kajiado',
    'Kakamega',
    'Kericho',
    'Kiambu',
    'Kilifi',
    'Kirinyaga',
    'Kisii',
    'Kisumu',
    'Kitui',
    'Kwale',
    'Laikipia',
    'Lamu',
    'Machakos',
    'Makueni',
    'Mandera',
    'Meru',
    'Migori',
    'Marsabit',
    'Mombasa',
    'Murang\'a',
    'Nairobi',
    'Nakuru',
    'Nandi',
    'Narok',
    'Nyamira',
    'Nyandarua',
    'Nyeri',
    'Samburu',
    'Siaya',
    'Taita-Taveta',
    'Tana River',
    'Tharaka-Nithi',
    'Trans Nzoia',
    'Turkana',
    'Uasin Gishu',
    'Vihiga',
    'Wajir',
    'West Pokot'
  ];

  List<String> filteredCounty() {
    if (searchCountyQuery.value.isEmpty) {
      return allCounties;
    } else {
      return allCounties
          .where((county) => county
              .toLowerCase()
              .contains(searchCountyQuery.value.toLowerCase()))
          .toList();
    }
  }

  List<String> filteredPropertyType() {
    if (searchTypeQuery.value.isEmpty) {
      return getPropertyTypes();
    } else {
      return getPropertyTypes()
          .where((type) =>
              type.toLowerCase().contains(searchTypeQuery.value.toLowerCase()))
          .toList();
    }
  }

  List<String> filteredAmenity() {
    if (searchAmenityQuery.value.isEmpty) {
      return getAmenities();
    } else {
      return getAmenities()
          .where((amenity) => amenity
              .toLowerCase()
              .contains(searchAmenityQuery.value.toLowerCase()))
          .toList();
    }
  }

  void setCountySearchQuery(String query) {
    searchCountyQuery.value = query;
    searchCountyController.text = query;
  }

  void clearCountySearchQuery() {
    searchCountyQuery.value = '';
  }

  void setTypeSearchQuery(String query) {
    searchTypeQuery.value = query;
    searchTypeController.text = query;
  }

  void clearTypeSearchQuery() {
    searchTypeQuery.value = '';
  }

  void setAmenitySearchQuery(String query) {
    searchAmenityQuery.value = query;
    searchAmenityController.text = query;
  }

  void clearAmenitySearchQuery() {
    searchAmenityQuery.value = '';
  }

  List<String> getPropertyTypes() => AddHouseController().houseTypes;

  List<String> getBedrooms() => AddHouseController().bedrooms;

  List<String> getBathrooms() => AddHouseController().bedrooms;
  List<String> getAmenities() => AddHouseController().amenities;

  void updateFiltersApplied() {
    filtersApplied.value = selectedCounty.isNotEmpty ||
        minPrice.isNotEmpty ||
        maxPrice.isNotEmpty ||
        selectedBedrooms.isNotEmpty ||
        selectedBathrooms.isNotEmpty ||
        selectedPropertyType.isNotEmpty ||
        selectedAmenity.isNotEmpty;
  }
}
