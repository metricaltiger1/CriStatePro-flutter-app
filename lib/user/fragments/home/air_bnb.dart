import 'package:cached_network_image/cached_network_image.dart';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/house/house.dart';
import 'package:cristatepro/house/house_details_page.dart';
import 'package:cristatepro/user/fragments/home/all_filter_houses.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AirBnBListings extends StatelessWidget {
  final RxList<HouseModel> houses;

  const AirBnBListings({super.key, required this.houses});

  @override
  Widget build(BuildContext context) {
    const String appBarTitle = "Air BNB Houses";

    return Obx(() {
      final airbnbListings = houses
          .where((house) => house.transactionType.toLowerCase() == 'book')
          .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Featured Airbnb',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Get.to(() => AllFilteredHousesPage(
                        houses: airbnbListings,
                        appBarTitle: appBarTitle,
                      ));
                },
                child: const Text(
                  "See all",
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          airbnbListings.isEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/image_placeholder.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200.0,
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: airbnbListings.map((house) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => UserHouseDetailScreen(house: house));
                        },
                        child: Container(
                          width: 220,
                          height: 130,
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.blue,
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Container(
                                height: double.infinity,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: API.profilemage +
                                        house.houseProfileImage,
                                    placeholder: (context, url) => Center(
                                      child: Lottie.asset(
                                        'assets/progressbar.json',
                                        width: 60,
                                        height: 60,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(.8),
                                      Colors.white.withOpacity(.01),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 12,
                                left: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      house.houseTitle,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 17,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          address(house.houseLocation),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ],
      );
    });
  }
}

String address(String locationString) {
  List<String> parts = locationString.split(', ');
  if (parts.length >= 4) {
    return '${parts[2]}, ${parts[3]}';
  } else {
    return '';
  }
}
