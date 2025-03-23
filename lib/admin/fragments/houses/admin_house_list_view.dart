import 'package:cristatepro/widgets/star_rating.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cristatepro/admin/controllers/admin_house_controller.dart';
import 'package:cristatepro/admin/fragments/houses/update_house.dart';
import 'package:cristatepro/house/house.dart';
import 'package:cristatepro/house/house_details_page.dart';
import 'package:cristatepro/widgets/house_card.dart';
import 'package:lottie/lottie.dart';

class AdminHouseListView extends StatelessWidget {
  final AdminHouseController houseController = Get.find();

  AdminHouseListView({super.key});

  @override
  Widget build(BuildContext context) {
    houseController.fetchAdminHouses();
    return Scaffold(
      appBar: AppBar(
        title: const Text('House List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              houseController.isSearching(true);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (houseController.isLoading.value) {
          return _buildLoadingView();
        } else {
          if (houseController.houses.isEmpty) {
            return _buildNoHouseView(context);
          } else {
            return _buildHouseListView(context);
          }
        }
      }),
    );
  }

  Widget _buildLoadingView() {
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

  Widget _buildHouseListView(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/housepage.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          if (houseController.isSearching.value) _buildSearchBar(context),
          Expanded(
            child: ListView.builder(
              key: const PageStorageKey<String>("houses"),
              itemCount: houseController.isSearching.value
                  ? houseController.filteredHouses.length
                  : houseController.houses.length,
              itemBuilder: (context, index) {
                final house = houseController.isSearching.value
                    ? houseController.filteredHouses[index]
                    : houseController.houses[index];
                return _buildHouseCard(context, house, index);
              },
            ),
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
                onChanged: (value) => houseController.filterHouses(value),
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

  Widget _buildHouseCard(BuildContext context, HouseModel house, int index) {
    return Stack(
      children: [
        Card(
          color: Colors.white60,
          margin: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async {
              final result = await Get.to(
                () => UserHouseDetailScreen(house: house),
              ) as bool?;
              if (result != null && result) {}
            },
            child: Column(
              children: [
                HouseCardWidget(house: house, index: index),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => UpdateHouseView(houseData: house));
                            },
                            child: const Text('Update'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showDeleteConfirmationDialog(context, house);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Total Rating: '),
                          StarRating(
                            rating: house.totalRatings.toDouble(),
                            totalStars: 5,
                            filledStar: Icons.star,
                            unfilledStar: Icons.star_border,
                            size: 24,
                            interactive: false,
                            halfFilledStar: Icons.star_half,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (houseController.isDeleting(house.houseId.toString()))
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Deleting...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
            ),
          ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, HouseModel house) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Do you want to delete this house?'),
          actions: [
            TextButton(
              onPressed: () {
                houseController.deleteAdminHouse(house.houseId.toString());
                Get.back();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
