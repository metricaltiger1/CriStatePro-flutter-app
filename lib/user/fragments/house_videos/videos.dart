import 'package:cached_network_image/cached_network_image.dart';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/house/house.dart';
import 'package:cristatepro/house/house_details_page.dart';
import 'package:cristatepro/user/controllers/home_controller.dart';
import 'package:cristatepro/user/controllers/houses_controller.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:cristatepro/widgets/customtext.dart';
import 'package:cristatepro/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class HouseVideoPage extends StatelessWidget {
  const HouseVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserHouseController>();
    final HomeScreenController homeScreenController =
        Get.put(HomeScreenController());
    final CurrentUser currentUser = Get.find<CurrentUser>();

    const PageStorageKey pageStorageKey = PageStorageKey('houseVideoPage');
    final ScrollController scrollController = ScrollController();

    bool isFetching = false;

    void fetchMoreHouses() {
      if (!isFetching) {
        isFetching = true;
        controller.fetchUserHouses().then((_) {
          isFetching = false;
        });
      }
    }

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isFetching) {
        fetchMoreHouses();
      }
    });

    return Scaffold(
      body: Obx(
        () {
          if (controller.isLoading.value && controller.houses.isEmpty) {
            return _buildLoadingIndicator();
          } else {
            if (controller.houses.isEmpty) {
              return _buildNoVideos();
            } else {
              return CustomScrollView(
                key: pageStorageKey,
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    floating: true,
                    centerTitle: true,
                    title: const Text('House Videos')
                        .animate(
                            delay: 200.ms,
                            onPlay: (controller) =>
                                controller.repeat(reverse: true))
                        .fadeIn(duration: 600.ms)
                        .then(delay: 2000.ms)
                        .slide()
                        .tint(color: Colors.amber)
                        .then()
                        .shake(),
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/icon/lightlogo.png'),
                    ),
                    actions: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child:
                            homeScreenController.buildProfileImage(currentUser),
                      ),
                    ],
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final house = controller.houses[index];
                        if (house.videoUrl.isNotEmpty) {
                          return _buildHouseItem(context, house);
                        } else {
                          return const SizedBox();
                        }
                      },
                      childCount: controller.houses.length,
                    ),
                  ),
                  if (controller.isLoading.value &&
                      controller.houses.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _buildProgressIndicator(),
                    ),
                ],
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildHouseItem(BuildContext context, HouseModel house) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: VideoPlayerWidget(
                videoUrl: API.houseVideo + house.videoUrl,
                imageUrl: API.profilemage + house.houseProfileImage,
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Get.to(() => UserHouseDetailScreen(
                    house: house,
                  ));
            },
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        imageUrl: API.profilemage + house.houseProfileImage,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/user.png'),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            house.houseTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              if (int.parse(house.houseBedrooms) > 0) ...[
                                const Icon(Icons.bed,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  '${house.houseBedrooms} BR | ',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                              CustomText(
                                label:
                                    'Ksh ${NumberFormat('#,###').format(house.housePrice)}',
                                fontSize: 18,
                                lableColor: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.location_on,
                          size: 19,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address(house.houseLocation),
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          maxLines: null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(
            color: Colors.grey,
            height: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Loading house videos...',
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
            const Text('Fetching more videos...'),
          ],
        ),
      ),
    );
  }

  Widget _buildNoVideos() {
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
            'No house Videos found.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
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
