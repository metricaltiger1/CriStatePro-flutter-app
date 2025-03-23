import 'package:cristatepro/house/house.dart';
import 'package:cristatepro/user/controllers/fav_controller.dart';
import 'package:cristatepro/house/house_details_page.dart';
import 'package:cristatepro/widgets/house_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class FavouriteFragmentScreen extends StatelessWidget {
  const FavouriteFragmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavouriteController controller = Get.find();
    controller.fetchFavouriteHouses();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourite Houses"),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.favouriteHouses.isEmpty) {
          return _buildLoadingIndicator();
        } else if (controller.favouriteHouses.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/broken_heart.json',
                  width: 150,
                  height: 150,
                ),
                const Text(
                  "No favourite houses yet.",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            key: const PageStorageKey<String>("ListOfFavorites"),
            itemCount: controller.favouriteHouses.length,
            itemBuilder: (context, index) {
              final house = controller.favouriteHouses[index];
              return buildHouseCard(context, house, controller, index);
            },
          );
        }
      }),
    );
  }

  Widget buildHouseCard(BuildContext context, HouseModel house,
      FavouriteController controller, int index) {
    bool isOddIndex = index % 2 == 0;
    return Card(
      color: Colors.white60,
      margin: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          InkWell(
            onTap: () async {
              Get.to(() => UserHouseDetailScreen(house: house));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HouseCardWidget(house: house, index: index),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: isOddIndex ? 10 : null,
            right: isOddIndex ? null : 10,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white38,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.delete_forever_sharp,
                  color: Colors.red,
                  size: 30,
                ),
                onPressed: () {
                  _showRemoveConfirmationDialog(context, house, controller);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveConfirmationDialog(
      BuildContext context, HouseModel house, FavouriteController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Remove from Favorites"),
          content: const Text(
              "Are you sure you want to remove this house from favorites?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                controller.removeFromFavorites(house);
                Get.forceAppUpdate();
                Get.back();
              },
              child: const Text("Remove"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Loading favourite houses...',
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
}
