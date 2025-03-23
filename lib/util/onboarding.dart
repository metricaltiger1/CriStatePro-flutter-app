import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;

  void setIndex(int index) {
    currentIndex.value = index;
  }

  void nextPage() {
    if (currentIndex.value < onboardingData.length - 1) {
      currentIndex.value++;
    } else {
      saveOnboardingStatus();
      Get.offAllNamed('/signin');
    }
  }

  void previousPage() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  Future<void> saveOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
  }

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Welcome to CrisTatePro!',
      'description':
          'Start your journey towards finding your perfect home. Let’s turn your dream living space into reality.',
      'image': 'assets/onboarding1.png',
    },
    {
      'title': 'Discover Your Ideal Home',
      'description':
          'Explore a wide range of properties tailored to fit your lifestyle. From cozy apartments to spacious houses, find it all here.',
      'image': 'assets/onboarding2.png',
    },
    {
      'title': 'Interactive Map Exploration',
      'description':
          'Navigate neighborhoods and discover nearby amenities with our intuitive map view. Find the perfect location for your new home.',
      'image': 'assets/onboarding3.png',
    },
    {
      'title': 'Stay Informed & Connected',
      'description':
          'Set alerts for new listings and connect directly with landlords. Secure your dream home before anyone else.',
      'image': 'assets/onboarding4.png',
    },
    {
      'title': 'Personalize Your Experience',
      'description':
          'Save your favourite listings and customize your search experience. Your perfect home is just a few taps away.',
      'image': 'assets/onboarding5.png',
    },
  ];
}

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: controller.onboardingData.length,
              controller: PageController(viewportFraction: 1),
              onPageChanged: controller.setIndex,
              itemBuilder: (context, index) {
                return Obx(() {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        controller.onboardingData[controller.currentIndex.value]
                            ['image']!,
                        fit: BoxFit.cover,
                        height: 300,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        controller.onboardingData[controller.currentIndex.value]
                            ['title']!,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          controller
                                  .onboardingData[controller.currentIndex.value]
                              ['description']!,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                });
              },
            ),
          ),
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (controller.currentIndex.value > 0)
                  TextButton(
                    onPressed: () {
                      controller.previousPage();
                    },
                    child: const Text(
                      'Back',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  )
                else
                  const SizedBox(),
                Row(
                  children:
                      List.generate(controller.onboardingData.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: controller.currentIndex.value == index ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: controller.currentIndex.value == index
                            ? Colors.blue
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                TextButton(
                  onPressed: () {
                    controller.nextPage();
                  },
                  child: Text(
                    controller.currentIndex.value <
                            controller.onboardingData.length - 1
                        ? 'Next'
                        : 'Finish',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
