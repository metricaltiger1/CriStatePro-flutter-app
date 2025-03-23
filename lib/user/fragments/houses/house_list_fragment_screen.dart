import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cristatepro/configs/constants.dart';
import 'package:cristatepro/house/house.dart';
import 'package:cristatepro/house/house_details_page.dart';
import 'package:cristatepro/services/notification.dart';
import 'package:cristatepro/user/controllers/fav_controller.dart';
import 'package:cristatepro/user/controllers/houses_controller.dart';
import 'package:cristatepro/widgets/house_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';

class UserHouseListView extends StatelessWidget {
  UserHouseListView({super.key});

  final UserHouseController houseController = Get.put(UserHouseController());
  final FavouriteController favouriteController =
      Get.put(FavouriteController());
  final ScrollController _scrollController = ScrollController();
  final PageStorageKey scrollKey = const PageStorageKey<String>('houseListKey');

  @override
  Widget build(BuildContext context) {
    houseController.fetchUserHouses();
    favouriteController.fetchFavouriteHouses();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        houseController.fetchUserHouses();
      }
    });

    return Scaffold(
      body: Obx(() {
        if (houseController.isLoading.value && houseController.houses.isEmpty) {
          return _buildLoadingIndicator();
        } else {
          if (houseController.houses.isEmpty) {
            return _buildNoHouseView(context);
          } else {
            return Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/housepage.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      if (houseController.isSearching.value)
                        _buildSearchBar(context),
                      Expanded(
                        child: CustomScrollView(
                          key: scrollKey,
                          controller: _scrollController,
                          slivers: [
                            if (!houseController.isSearching.value)
                              SliverAppBar(
                                floating: true,
                                centerTitle: true,
                                title: const Text('House List')
                                    .animate(
                                      delay: 200.ms,
                                      onPlay: (controller) =>
                                          controller.repeat(reverse: true),
                                    )
                                    .fadeIn(duration: 600.ms)
                                    .then(delay: 2000.ms)
                                    .slide()
                                    .tint(color: Colors.amber)
                                    .then()
                                    .shake(),
                                leading: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset('assets/icon/icon.jpg'),
                                ),
                                actions: [
                                  IconButton(
                                    onPressed: () {
                                      houseController.isSearching.value =
                                          !houseController.isSearching.value;
                                    },
                                    icon: const Icon(Icons.search),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      houseController.showFilters.toggle();
                                    },
                                    icon: Icon(
                                      Icons.filter_list,
                                      color:
                                          houseController.filtersApplied.value
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  if (houseController.isSearching.value ||
                                      houseController.filtersApplied.value) {
                                    if (houseController
                                        .filteredHouses.isEmpty) {
                                      return _buildNoMatchingHouseView();
                                    } else {
                                      final house =
                                          houseController.filteredHouses[index];
                                      final isLiked = favouriteController
                                          .favouriteHouses
                                          .any((favHouse) =>
                                              favHouse.houseId ==
                                              house.houseId);
                                      return _buildHouseCard(
                                          context, house, isLiked, index);
                                    }
                                  } else {
                                    final house = houseController.houses[index];
                                    final isLiked = favouriteController
                                        .favouriteHouses
                                        .any((favHouse) =>
                                            favHouse.houseId == house.houseId);
                                    return _buildHouseCard(
                                        context, house, isLiked, index);
                                  }
                                },
                                childCount: houseController.isSearching.value ||
                                        houseController.filtersApplied.value
                                    ? houseController.filteredHouses.isEmpty
                                        ? 1
                                        : houseController.filteredHouses.length
                                    : houseController.houses.length,
                              ),
                            ),
                            if (houseController.isLoading.value &&
                                houseController.houses.isNotEmpty)
                              SliverToBoxAdapter(
                                  child: _buildProgressIndicator()),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Obx(() {
                    if (houseController.showFilters.value) {
                      return Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Column(
                                children: [
                                  AppBar(
                                    title: const Text("Filter Options"),
                                    leading: IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        houseController.showFilters.value =
                                            false;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: _buildFilterOptions(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                ],
              ),
            );
          }
        }
      }),
    );
  }

  Widget _buildNoHouseView(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/house_listing.json',
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 20),
          const Text(
            'No houses found.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoMatchingHouseView() {
    return SizedBox(
      width: double.infinity,
      child: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Column(
            children: [
              Lottie.asset(
                'assets/broken_heart.json',
                width: 150,
                height: 150,
              ),
              const Text(
                'No houses found matching the selected criteria.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Loading houses...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Lottie.asset(
            'assets/progressbar.json',
            width: 60,
            height: 60,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            const Icon(Icons.search),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: houseController.searchController,
                onChanged: (value) => houseController.searchHouses(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                ),
              ),
            ),
            TextButton(
              onPressed: houseController.cancelSearch,
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHouseCard(
      BuildContext context, HouseModel house, bool isLiked, int index) {
    bool isOddIndex = index % 2 == 0;
    return Card(
      color: Colors.white60,
      margin: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Get.to(() => UserHouseDetailScreen(house: house));
            },
            child: Column(
              children: [
                HouseCardWidget(house: house, index: index),
              ],
            ),
          ),
          Positioned(
            top: 10,
            left: isOddIndex ? 10 : null,
            right: isOddIndex ? null : 10,
            child: LikeButton(
              size: 30,
              animationDuration: const Duration(seconds: 1),
              circleColor: const CircleColor(
                start: Colors.red,
                end: Colors.redAccent,
              ),
              likeBuilder: (isLiked) {
                return Icon(
                  Icons.favorite,
                  color: isLiked ? Colors.red : Colors.blueGrey,
                  size: 40,
                );
              },
              isLiked: isLiked,
              onTap: (isLiked) async {
                final message = isLiked
                    ? 'House removed from favorites'
                    : 'House added to favorites';
                final backgroundColor = isLiked
                    ? Colors.red.withOpacity(0.5)
                    : Colors.green.withOpacity(0.5);
                final icon = isLiked ? Icons.remove_circle : Icons.check;

                Get.snackbar(
                  message,
                  'The house has been ${isLiked ? 'removed from' : 'added to'} your favorites.',
                  backgroundColor: backgroundColor,
                  snackPosition: SnackPosition.TOP,
                  margin: const EdgeInsets.all(8),
                  borderRadius: 10,
                  duration: const Duration(seconds: 3),
                  icon: Icon(icon, color: Colors.white),
                  snackStyle: SnackStyle.FLOATING,
                  overlayColor: Colors.black.withOpacity(0.3),
                  overlayBlur: 1,
                );
                favouriteController.toggleFavorite(house);
                return !isLiked;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Column(
          children: [
            Lottie.asset(
              'assets/progressbar.json',
              width: 30,
              height: 30,
            ),
            const SizedBox(height: 8),
            const Text('Fetching more data...'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi ${currentUser.user.userFirstName} ${Emojis.smile_face_with_tongue} let\'s find your perfect home today!',
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
                shadows: [
                  Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 4.0,
                      color: Color.fromARGB(150, 0, 0, 0))
                ]),
          ),
          const SizedBox(height: 8),
          Wrap(
            children: [
              buildFilterButton(
                title: 'Location',
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.lightBlue[50],
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  height: 400,
                  child: Column(
                    children: [
                      Obx(
                        () => TextField(
                            controller: houseController.searchCountyController,
                            onChanged: (query) {
                              houseController.setCountySearchQuery(query);
                            },
                            decoration: InputDecoration(
                                hintText: 'Search Counties',
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    color: appGrayColor,
                                  ),
                                ),
                                suffixIcon: houseController
                                        .searchCountyQuery.value.isEmpty
                                    ? const Icon(Icons.search)
                                    : IconButton(
                                        icon: const Icon(Icons.cancel),
                                        onPressed: () {
                                          houseController
                                              .clearCountySearchQuery();
                                          houseController.searchCountyController
                                              .clear();
                                        },
                                      ))),
                      ),
                      Expanded(
                        child: Obx(() {
                          var counties = houseController.filteredCounty();
                          if (counties.isEmpty) {
                            return Center(
                                child: Text(
                                    "No counties found that matches '${houseController.searchCountyController.text}'"));
                          }
                          return SingleChildScrollView(
                            child: Column(
                              children: houseController
                                  .filteredCounty()
                                  .map((county) {
                                return CheckboxListTile(
                                  title: Text(county),
                                  value: houseController.selectedCounty
                                      .contains(county),
                                  onChanged: (value) {
                                    houseController.toggleCounty(county);
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              buildFilterButton(
                title: 'Property Type',
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.lightGreen[50],
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  height: 400,
                  child: Column(
                    children: [
                      Obx(
                        () => TextField(
                            controller: houseController.searchTypeController,
                            onChanged: (query) {
                              houseController.setTypeSearchQuery(query);
                            },
                            decoration: InputDecoration(
                                hintText: 'Search house type',
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    color: appGrayColor,
                                  ),
                                ),
                                suffixIcon: houseController
                                        .searchTypeQuery.value.isEmpty
                                    ? const Icon(Icons.search)
                                    : IconButton(
                                        icon: const Icon(Icons.cancel),
                                        onPressed: () {
                                          houseController
                                              .clearTypeSearchQuery();
                                          houseController.searchTypeController
                                              .clear();
                                        },
                                      ))),
                      ),
                      Expanded(
                        child: Obx(() {
                          var type = houseController.filteredPropertyType();
                          if (type.isEmpty) {
                            return Center(
                                child: Text(
                                    "No property type found that matches '${houseController.searchTypeController.text}'"));
                          }
                          return SingleChildScrollView(
                            child: Column(
                              children: houseController
                                  .filteredPropertyType()
                                  .map((type) {
                                return CheckboxListTile(
                                  title: Text(type),
                                  value: houseController.selectedPropertyType
                                      .contains(type),
                                  onChanged: (value) {
                                    houseController.togglePropertyType(type);
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              buildFilterButton(
                title: 'Amenities',
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.yellow[50],
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  height: 400,
                  child: Column(
                    children: [
                      Obx(
                        () => TextField(
                            controller: houseController.searchAmenityController,
                            onChanged: (query) {
                              houseController.setAmenitySearchQuery(query);
                            },
                            decoration: InputDecoration(
                                hintText: 'Search house amenity',
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    color: appGrayColor,
                                  ),
                                ),
                                suffixIcon: houseController
                                        .searchAmenityQuery.value.isEmpty
                                    ? const Icon(Icons.search)
                                    : IconButton(
                                        icon: const Icon(Icons.cancel),
                                        onPressed: () {
                                          houseController
                                              .clearAmenitySearchQuery();
                                          houseController
                                              .searchAmenityController
                                              .clear();
                                        },
                                      ))),
                      ),
                      Expanded(
                        child: Obx(() {
                          var amenity = houseController.filteredAmenity();
                          if (amenity.isEmpty) {
                            return Center(
                                child: Text(
                                    "No property with amenity found that matches '${houseController.searchAmenityController.text}'"));
                          }
                          return SingleChildScrollView(
                            child: Column(
                              children: houseController
                                  .filteredAmenity()
                                  .map((amenity) {
                                return CheckboxListTile(
                                  title: Text(amenity),
                                  value: houseController.selectedAmenity
                                      .contains(amenity),
                                  onChanged: (value) {
                                    houseController.toggleAmenity(amenity);
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              buildFilterButton(
                title: 'Price',
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.pink[50],
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: houseController.minPriceController,
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.monetization_on_outlined),
                          suffixIcon:
                              houseController.minPriceController.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        houseController.clearMinPrice();
                                      },
                                      icon: const Icon(Icons.clear_outlined))
                                  : null,
                          hintText: 'Min Price',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: appGrayColor,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          houseController.setMinPrice(value);
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: houseController.maxPriceController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.monetization_on),
                          suffixIcon:
                              houseController.maxPriceController.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        houseController.clearMaxPrice();
                                      },
                                      icon: const Icon(Icons.clear_outlined))
                                  : null,
                          hintText: 'Max Price',
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: appGrayColor,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          houseController.setMaxPrice(value);
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              buildFilterButton(
                title: 'Bedrooms',
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.purple[50],
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  height: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: houseController.getBedrooms().map((number) {
                        return CheckboxListTile(
                          title: Text('$number Bedrooms'),
                          value: houseController.selectedBedrooms
                              .contains(int.parse(number)),
                          onChanged: (value) {
                            houseController.toggleBedrooms(int.parse(number));
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              buildFilterButton(
                title: 'Bathrooms',
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.orange[50],
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  height: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: houseController.getBathrooms().map((number) {
                        return CheckboxListTile(
                          title: Text('$number Bathrooms'),
                          value: houseController.selectedBathrooms
                              .contains(int.parse(number)),
                          onChanged: (value) {
                            houseController.toggleBathrooms(int.parse(number));
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (houseController.filtersApplied.value)
                ElevatedButton.icon(
                  onPressed: () {
                    houseController.applyFilters();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      elevation: 5),
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Apply Filters'),
                ),
              const SizedBox(width: 20),
              if (houseController.filtersApplied.value)
                ElevatedButton.icon(
                  onPressed: () {
                    houseController.clearFilters();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      elevation: 5),
                  icon: const Icon(Icons.clear),
                  label: const Text(
                    'Clear Filters',
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() {
            if (houseController.filteredHouses.isEmpty &&
                houseController.filtersApplied.value) {
              return _buildNoMatchingHouseView();
            } else {
              return Column(
                children: [
                  if (houseController.filtersApplied.value == true)
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Explore your tailored options:",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                  shadows: [
                                    Shadow(
                                        offset: Offset(2.0, 2.0),
                                        blurRadius: 3.0,
                                        color:
                                            Color.fromARGB(19, 202, 195, 195))
                                  ]),
                            ),
                          ),
                        ),
                        if (houseController.selectedCounty.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Location: ${houseController.selectedCounty.join(', ')}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                        if (houseController.selectedPropertyType.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Property type: ${houseController.selectedPropertyType.join(', ')}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                        if (houseController.selectedAmenity.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.yellow[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Amenity: ${houseController.selectedAmenity.join(', ')}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                        if (houseController.minPriceController.text.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.pink[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Price Range: ${houseController.minPriceController.text} - ${houseController.maxPriceController.text} ',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                        if (houseController.selectedBedrooms.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.purple[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Bedroom: ${houseController.selectedBedrooms.join(', ')}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                        if (houseController.selectedBedrooms.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Batheroom: ${houseController.selectedBathrooms.join(', ')}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          )
                      ],
                    ),
                  const SizedBox(height: 8),
                  if (houseController.filtersApplied.value &&
                      houseController.showFilters.value == true)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          ' Items found: ${houseController.filteredHouses.length} ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox.shrink(),
                ],
              );
            }
          }),
        ],
      ),
    );
  }

  Widget buildFilterButton({required String title, required Widget content}) {
    return Obx(
      () {
        final isExpanded = houseController.expandedFilter.value == title;
        return ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 300,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  houseController.toggleFilter(title);
                },
                child: Chip(
                  label: Text(title),
                  avatar:
                      Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                ),
              ),
              if (isExpanded)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: content,
                ),
            ],
          ),
        );
      },
    );
  }
}
