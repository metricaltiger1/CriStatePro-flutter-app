import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/house/house.dart';
import 'package:cristatepro/house/house_details_page.dart';
import 'package:cristatepro/user/fragments/home/all_filter_houses.dart';
import 'package:cristatepro/widgets/star_rating.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class Offices extends StatelessWidget {
  final RxList<HouseModel> houses;
  final RxInt _currentHouse = RxInt(0);

  Offices({super.key, required this.houses});

  @override
  Widget build(BuildContext context) {
    const String appBarTitle = "Offices";

    return Obx(() {
      final airbnbListings = houses
          .where((house) => house.transactionType.toLowerCase() == 'office')
          .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Office spaces',
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
              : CarouselSlider.builder(
                  itemCount: airbnbListings.length,
                  itemBuilder: (context, index, realIndex) {
                    final house = airbnbListings[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => UserHouseDetailScreen(house: house));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  API.profilemage + house.houseProfileImage,
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
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.25,
                            ),
                            Positioned(
                              top: 10,
                              left: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    house.houseTitle,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      if (int.parse(house.houseBedrooms) >
                                          0) ...[
                                        const Icon(Icons.bed,
                                            size: 15, color: Colors.white),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${house.houseBedrooms} BR',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                      if (int.parse(house.houseBedrooms) > 0 &&
                                          int.parse(house.houseBathrooms) >
                                              0) ...[
                                        const SizedBox(width: 8),
                                      ],
                                      if (int.parse(house.houseBathrooms) >
                                          0) ...[
                                        const Icon(Icons.bathtub,
                                            size: 15, color: Colors.white),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${house.houseBathrooms} BA',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    'Ksh ${NumberFormat('#,###').format(house.housePrice)}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  StarRating(
                                    rating: house.averageRating.toDouble(),
                                    totalStars: 5,
                                    filledStar: Icons.star,
                                    unfilledStar: Icons.star_border,
                                    size: 20,
                                    interactive: false,
                                    halfFilledStar: Icons.star_half,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: 180.0,
                    viewportFraction: 1.0,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 700),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    pauseAutoPlayOnTouch: true,
                    aspectRatio: 2.0,
                    enableInfiniteScroll: true,
                    onPageChanged: (index, reason) {
                      _currentHouse.value = index;
                    },
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: airbnbListings.asMap().entries.map((entry) {
              final index = entry.key;
              return Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentHouse.value == index
                      ? Colors.blueAccent
                      : Colors.grey,
                ),
              );
            }).toList(),
          )
        ],
      );
    });
  }
}
