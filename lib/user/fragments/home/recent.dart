import 'package:cached_network_image/cached_network_image.dart';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/house/house.dart';
import 'package:cristatepro/house/house_details_page.dart';
import 'package:cristatepro/user/fragments/home/all_filter_houses.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RecentItem extends StatelessWidget {
  final RxList<HouseModel> houses;
  final RxInt _currentHouse = RxInt(0);

  RecentItem({super.key, required this.houses});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final recentHouse = houses.toList().reversed.take(10).toList();
      const String appBarTitle = "Recently Listed Houses";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Recently listed',
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
                      houses: recentHouse, appBarTitle: appBarTitle));
                },
                child: const Text(
                  "See all",
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          recentHouse.isEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/image_placeholder.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200.0,
                  ),
                )
              : CarouselSlider(
                  options: CarouselOptions(
                    height: 150.0,
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
                  items: recentHouse.map((house) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => UserHouseDetailScreen(house: house));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
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
                                width: 120,
                                height: 120,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    house.houseTitle,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      if (int.parse(house.houseBedrooms) >
                                          0) ...[
                                        const Icon(Icons.bed,
                                            size: 15, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${house.houseBedrooms} BR',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
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
                                            size: 15, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${house.houseBathrooms} BA',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Ksh ${NumberFormat('#,###').format(house.housePrice)}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Expanded(
                                    child: RichText(
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      text: TextSpan(
                                        children: [
                                          const WidgetSpan(
                                            child: Icon(
                                              Icons.location_on,
                                              size: 17,
                                            ),
                                          ),
                                          TextSpan(
                                            text: address(house.houseLocation),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
        ],
      );
    });
  }

  String address(String locationString) {
    List<String> parts = locationString.split(', ');
    if (parts.length >= 4) {
      return '${parts[2]}, ${parts[3]}';
    } else {
      return '';
    }
  }
}
