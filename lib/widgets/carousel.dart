import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/house/house.dart';
import 'package:lottie/lottie.dart';
import 'package:palette_generator/palette_generator.dart';

class ImageCarousel extends StatelessWidget {
  final HouseModel houseModel;
  final RxInt _currentImageIndex = RxInt(0);
  final List<String> displayImages;

  ImageCarousel({
    super.key,
    required this.houseModel,
  }) : displayImages = houseModel.displayImages;

  @override
  Widget build(BuildContext context) {
    var profileImageUrl = API.profilemage + houseModel.houseProfileImage;
    List<String> allImages = [profileImageUrl, ...displayImages];

    return Column(
      children: [
        if (allImages.isNotEmpty)
          Stack(
            children: [
              CarouselSlider.builder(
                itemCount: allImages.length,
                itemBuilder: (context, index, realIndex) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() =>
                          ImageCarouselFullScreen(houseModel: houseModel));
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0.0),
                        color: Colors.white38,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0.0),
                        child: CachedNetworkImage(
                          imageUrl: index == 0
                              ? allImages[index]
                              : API.displayImages + allImages[index],
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
                  );
                },
                options: CarouselOptions(
                  height: 400.0,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 700),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: true,
                  enableInfiniteScroll: true,
                  onPageChanged: (index, reason) {
                    _currentImageIndex.value = index;
                  },
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: allImages.asMap().entries.map((entry) {
                      final index = entry.key;
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex.value == index
                              ? Colors.blueAccent
                              : Colors.grey,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class ImageCarouselFullScreen extends StatelessWidget {
  final HouseModel houseModel;

  const ImageCarouselFullScreen({super.key, required this.houseModel});

  @override
  Widget build(BuildContext context) {
    final RxInt currentImageIndex = RxInt(0);

    final List<String> displayImages = houseModel.displayImages;

    final List<String> allImages = [
      API.profilemage + houseModel.houseProfileImage,
      ...displayImages.map((image) => API.displayImages + image),
    ];

    final Rx<Color> backgroundColor = Colors.transparent.obs;

    void updateBackgroundColor(int index) async {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(allImages[index]),
        size: const Size(200, 200),
      );

      if (paletteGenerator.dominantColor != null) {
        backgroundColor.value = paletteGenerator.dominantColor!.color;
      } else {
        backgroundColor.value = Colors.transparent;
      }
    }

    updateBackgroundColor(0);

    return Scaffold(
      appBar: AppBar(
        title: Text(houseModel.houseType),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Stack(
        children: [
          Obx(
            () => Container(
              color: backgroundColor.value,
              child: CarouselSlider.builder(
                itemCount: allImages.length,
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl: allImages[index],
                        placeholder: (context, url) => Center(
                          child: Lottie.asset(
                            'assets/progressbar.json',
                            width: 60,
                            height: 60,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 700),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: true,
                  enableInfiniteScroll: true,
                  onPageChanged: (index, reason) {
                    currentImageIndex.value = index;
                    updateBackgroundColor(index);
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: allImages.asMap().entries.map((entry) {
                  final index = entry.key;
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: currentImageIndex.value == index
                          ? Colors.blueAccent
                          : Colors.grey,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
