import 'package:cristatepro/user/controllers/fav_controller.dart';
import 'package:cristatepro/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/house/house.dart';
import 'package:cristatepro/widgets/star_rating.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:cristatepro/house/house_details_page.dart';
import 'package:like_button/like_button.dart';
import 'package:lottie/lottie.dart';

class AllFilteredHousesPage extends StatelessWidget {
  final List<HouseModel> houses;
  final String appBarTitle;

  const AllFilteredHousesPage(
      {super.key, required this.houses, required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final FavouriteController favouriteController =
        Get.put(FavouriteController());

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: CustomAppBar(
          title: appBarTitle,
          centerTitle: true,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Visibility(
        visible: houses.isNotEmpty,
        replacement: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/not_found.json',
              width: 200,
              height: 200,
            ),
            const Center(
              child: Text('No houses to display'),
            ),
          ],
        ),
        child: ListView.builder(
          key: const PageStorageKey<String>("houses"),
          itemCount: (houses.length / 2).ceil(),
          itemBuilder: (context, index) {
            final int firstIndex = index * 2;
            final int secondIndex = firstIndex + 1;
            final bool isLast = secondIndex >= houses.length;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: HouseCard(
                      house: houses[firstIndex],
                      isLiked: favouriteController.favouriteHouses.any(
                          (favHouse) =>
                              favHouse.houseId == houses[firstIndex].houseId),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: isLast
                        ? const SizedBox()
                        : HouseCard(
                            house: houses[secondIndex],
                            isLiked: favouriteController.favouriteHouses.any(
                                (favHouse) =>
                                    favHouse.houseId ==
                                    houses[secondIndex].houseId),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class HouseCard extends StatelessWidget {
  final HouseModel house;
  final bool isLiked;

  const HouseCard({super.key, required this.house, required this.isLiked});

  @override
  Widget build(BuildContext context) {
    final FavouriteController favouriteController =
        Get.put(FavouriteController());
    return GestureDetector(
      onTap: () {
        Get.to(() => UserHouseDetailScreen(house: house));
      },
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      API.profilemage + house.houseProfileImage,
                      height: 120.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    house.houseTitle,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    'Ksh ${NumberFormat('#,###').format(house.housePrice)}',
                    style: const TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  StarRating(
                    rating: house.averageRating.toDouble(),
                    totalStars: 5,
                    filledStar: Icons.star,
                    unfilledStar: Icons.star_border,
                    size: 24,
                    interactive: false,
                    halfFilledStar: Icons.star_half,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        const WidgetSpan(
                          child: Icon(
                            Icons.location_on,
                            size: 19,
                          ),
                        ),
                        TextSpan(
                          text: address(house.houseLocation),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
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
}

String address(String locationString) {
  List<String> parts = locationString.split(', ');
  if (parts.length >= 4) {
    return '${parts[2]}, ${parts[3]}';
  } else {
    return '';
  }
}
