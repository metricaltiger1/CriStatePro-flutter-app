import 'package:cristatepro/admin/fragments/message_body_screen.dart';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/house/amenity_icons.dart';
import 'package:cristatepro/house/map.dart';
import 'package:cristatepro/user/controllers/fav_controller.dart';
import 'package:cristatepro/user/controllers/rating_controller.dart';
import 'package:cristatepro/house/house.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:cristatepro/widgets/carousel.dart';
import 'package:cristatepro/widgets/star_rating.dart';
import 'package:cristatepro/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:like_button/like_button.dart';
import 'package:url_launcher/url_launcher.dart';

class UserHouseDetailScreen extends StatelessWidget {
  final HouseModel house;
  final CurrentUser currentUser = Get.put(CurrentUser());
  final RatingController ratingController = Get.put(RatingController());
  final RxBool isRatingVisible = false.obs;

  UserHouseDetailScreen({super.key, required this.house});

  @override
  Widget build(BuildContext context) {
    final FavouriteController favouriteController =
        Get.put(FavouriteController());
    bool isLiked = favouriteController.isHouseFavorited(house);
    return Scaffold(
        body: Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageCarousel(houseModel: house),
              const SizedBox(height: 210),
              SizedBox(height: MediaQuery.of(context).size.height * 0.37),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.03,
          left: 14,
          right: 14,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                  color: Colors.white30,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              Expanded(
                child: Text(
                  house.houseType,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.32,
          right: 20,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
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
                  overlayBlur: 2,
                );

                favouriteController.toggleFavorite(house);
                return !isLiked;
              },
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.37,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.home,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              house.houseTitle,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (int.parse(house.houseBedrooms) > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.king_bed,
                                      color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${int.parse(house.houseBedrooms)} ${int.parse(house.houseBedrooms) == 1 ? 'Bedroom' : 'Bedrooms'}',
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(width: 16),
                          if (int.parse(house.houseBathrooms) > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.bathtub,
                                      color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${int.parse(house.houseBathrooms)} ${int.parse(house.houseBathrooms) == 1 ? 'Bathroom' : 'Bathrooms'}',
                                    style: const TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Transaction',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Text.rich(
                                house.transactionType.toLowerCase() == 'office'
                                    ? TextSpan(
                                        text: 'Book this office for ',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87),
                                        children: [
                                          TextSpan(
                                            text:
                                                'Ksh ${NumberFormat('#,###').format(house.housePrice)} per month',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    : TextSpan(
                                        text: house.transactionType
                                                    .toLowerCase() ==
                                                'rent'
                                            ? 'Rent this house for '
                                            : house.transactionType
                                                        .toLowerCase() ==
                                                    'book'
                                                ? 'Book this house for '
                                                : 'Buy this house for ',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black87),
                                        children: [
                                          TextSpan(
                                            text: house.transactionType
                                                        .toLowerCase() ==
                                                    'book'
                                                ? 'Ksh ${NumberFormat('#,###').format(house.housePrice)} per night'
                                                : 'Ksh ${NumberFormat('#,###').format(house.housePrice)}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          if (house.transactionType
                                                  .toLowerCase() ==
                                              'rent')
                                            const TextSpan(text: ' per month'),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: Colors.blue,
                            size: 30.0,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Amenities:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children:
                            house.houseAmenities.split(',').map((amenity) {
                          final trimmedAmenity = amenity.trim();
                          if (AmenityIcons.amenityIcons
                              .containsKey(trimmedAmenity)) {
                            return Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.lightBlueAccent,
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.lightBlueAccent.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    AmenityIcons.amenityIcons[trimmedAmenity],
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    trimmedAmenity,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.description,
                                color: Colors.blue,
                                size: 30.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Description:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              house.houseDescription,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                house.transactionType.toLowerCase() == 'office'
                                    ? Icons.business_center
                                    : house.transactionType.toLowerCase() ==
                                            'rent'
                                        ? Icons.house
                                        : Icons.shopping_cart,
                                color: Colors.blue,
                                size: 30.0,
                              ),
                              const SizedBox(width: 8.0),
                              SizedBox(
                                width: 300,
                                child: Text(
                                  house.transactionType.toLowerCase() ==
                                          'office'
                                      ? 'Office Booking Terms and Conditions:'
                                      : house.transactionType.toLowerCase() ==
                                              'rent'
                                          ? 'Rental Terms and Conditions:'
                                          : house.transactionType
                                                      .toLowerCase() ==
                                                  'book'
                                              ? 'Booking Terms and Conditions:'
                                              : 'Sales Terms and Conditions:',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              house.rentalTerms,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.phone_android,
                                color: Colors.blue,
                                size: 30.0,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Contact Information:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Text(
                              house.contactInfo,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (currentUser.user.userId != house.userId)
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => MessageBodyScreen(
                                          senderId: currentUser.user.userId,
                                          propertyId: house.houseId,
                                          receiverId: house.userId,
                                        ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.withOpacity(0.8),
                                          Colors.blue.withOpacity(0.6)
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Get Started",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Image.asset(
                                          'assets/chat.png',
                                          width: 20.0,
                                          height: 20.0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: InteractiveMap(
                                location: location(house.houseLocation)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          _launchGoogleMaps(location(house.houseLocation));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Image.asset(
                                  'assets/location.png',
                                  width: 30.0,
                                  height: 30.0,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      address(house.houseLocation),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (house.videoUrl.isNotEmpty) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.video_library,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Video',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: VideoPlayerWidget(
                                    videoUrl: API.houseVideo + house.videoUrl,
                                    imageUrl: API.profilemage +
                                        house.houseProfileImage),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ],
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'House Rating:',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
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
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Obx(() {
                            if (isRatingVisible.value) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.rate_review,
                                          color: Colors.blue,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Rate this house:',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                        ),
                                        StarRating(
                                          rating:
                                              ratingController.userRating.value,
                                          totalStars: 5,
                                          filledStar: Icons.star,
                                          unfilledStar: Icons.star_border,
                                          size: 24,
                                          interactive: true,
                                          halfFilledStar: Icons.star_half,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          isRatingVisible.value = false;
                                          ratingController.setUserRating(0.0);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final double rating =
                                              ratingController.userRating.value;
                                          if (rating >= 1 && rating <= 5) {
                                            await ratingController.sendRating(
                                              rating,
                                              house.houseId,
                                              currentUser.user.userId,
                                            );
                                            isRatingVisible.value = false;
                                          } else {
                                            Get.snackbar(
                                              'Error',
                                              'Please select a rating between 1 and 5.',
                                              backgroundColor: Colors.red,
                                              snackPosition: SnackPosition.TOP,
                                            );
                                          }
                                          ratingController.setUserRating(0.0);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        child: const Text(
                                          'Confirm',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            } else {
                              return ElevatedButton(
                                onPressed: () => isRatingVisible.value = true,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Text(
                                  'Rate this house',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              );
                            }
                          }),
                        ],
                      )
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  LatLng location(String locationString) {
    List<String> parts = locationString.split(', ');
    if (parts.length >= 2) {
      double latitude = double.tryParse(parts[0]) ?? 0.0;
      double longitude = double.tryParse(parts[1]) ?? 0.0;
      return LatLng(latitude, longitude);
    } else {
      return const LatLng(0.0, 0.0);
    }
  }

  Future<void> _launchGoogleMaps(LatLng location) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  String address(String locationString) {
    List<String> parts = locationString.split(', ');
    if (parts.length >= 3) {
      return parts.sublist(2).join(', ');
    } else {
      return '';
    }
  }
}
