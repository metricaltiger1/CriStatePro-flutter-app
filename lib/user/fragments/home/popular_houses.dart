import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/house/house.dart';
import 'package:cristatepro/house/house_details_page.dart';
import 'package:cristatepro/user/controllers/fav_controller.dart';
import 'package:cristatepro/user/fragments/home/all_filter_houses.dart';
import 'package:cristatepro/widgets/star_rating.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';

class PopularHousesCarousel extends StatelessWidget {
  final RxList<HouseModel> houses;
  final RxInt _currentHouse = RxInt(0);

  PopularHousesCarousel({super.key, required this.houses});

  @override
  Widget build(BuildContext context) {
    final FavouriteController favouriteController =
        Get.put(FavouriteController());
    const String appBarTitle = "Popular Houses";

    return Obx(() {
      final popularHouses = houses
          .where((house) => house.averageRating >= 4.0)
          .toList()
          .take(5)
          .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Top Rated',
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
                        houses: popularHouses,
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
          popularHouses.isEmpty
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
                  itemCount: popularHouses.length,
                  itemBuilder: (context, index, realIndex) {
                    final house = popularHouses[index];
                    final bool isLiked = favouriteController.favouriteHouses
                        .any((favHouse) => favHouse.houseId == house.houseId);
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => UserHouseDetailScreen(house: house));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 240,
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.1),
                              spreadRadius: .5,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(16),
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
                                    borderRadius: BorderRadius.circular(16),
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
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        house.houseTitle,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          if (int.parse(house.houseBedrooms) >
                                              0) ...[
                                            const Icon(Icons.bed,
                                                size: 14, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${house.houseBedrooms} BR',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                          if (int.parse(house.houseBedrooms) >
                                                  0 &&
                                              int.parse(house.houseBathrooms) >
                                                  0) ...[
                                            const SizedBox(width: 8),
                                          ],
                                          if (int.parse(house.houseBathrooms) >
                                              0) ...[
                                            const Icon(Icons.bathtub,
                                                size: 14, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${house.houseBathrooms} BA',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                          StarRating(
                                            rating:
                                                house.averageRating.toDouble(),
                                            totalStars: 5,
                                            filledStar: Icons.star,
                                            unfilledStar: Icons.star_border,
                                            size: 14,
                                            interactive: false,
                                            halfFilledStar: Icons.star_half,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Ksh ${NumberFormat('#,###').format(house.housePrice)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 14,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              address(house.houseLocation),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 20,
                              top: 130,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(8),
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
                                      color: isLiked
                                          ? Colors.red
                                          : Colors.blueGrey,
                                      size: 30,
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
                                    final icon = isLiked
                                        ? Icons.remove_circle
                                        : Icons.check;

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
                                      overlayColor:
                                          Colors.black.withOpacity(0.3),
                                      overlayBlur: 1,
                                    );
                                    favouriteController.toggleFavorite(house);
                                    return !isLiked;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.35,
                    enlargeCenterPage: true,
                    disableCenter: true,
                    viewportFraction: .8,
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
            children: popularHouses.asMap().entries.map((entry) {
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
          ),
        ],
      );
    });
  }
}
