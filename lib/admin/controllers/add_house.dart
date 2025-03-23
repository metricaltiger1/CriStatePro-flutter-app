import 'dart:convert';
import 'dart:io';
import 'package:cristatepro/admin/controllers/admin_house_controller.dart';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/services/notification.dart';
import 'package:cristatepro/user/controllers/subscription.dart';
import 'package:cristatepro/user/fragments/more/pricing.dart';
import 'package:cristatepro/user/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class AddHouseController extends GetxController {
  final CurrentUser _currentUser = Get.find();
  final SubscriptionController subscriptionController =
      Get.put(SubscriptionController());

  final AdminHouseController _adminHouseController = Get.find();

  final TextEditingController titleController = TextEditingController();
  final RxString selectedHouseType = RxString('');
  final RxString selectedTransactionType = RxString('');
  final TextEditingController houseDescriptionController =
      TextEditingController();
  final RxString selectedBedroom = RxString('');
  final RxString selectedBathroom = RxString('');
  final RxList<String> selectedAmenities = <String>[].obs;

  final TextEditingController rentalTermsController = TextEditingController();
  final TextEditingController contactInfoController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final Rx<File?> houseProfileImage = Rx<File?>(null);
  final RxList<File> displayImages = <File>[].obs;
  final TextEditingController ratingController = TextEditingController();
  final NotificationManager notificationManager = NotificationManager();

  List<String> houseTypes = [
    'Apartment',
    'Villa',
    'Bedsitter',
    'Condo',
    'Townhouse',
    'House',
    'Air BNB',
    'Office',
    'Bungalow',
    'Cottage',
    'Mansion',
    'Farmhouse',
    'Mobile Home',
    'Ranch House',
    'Chalet',
    'Log Cabin',
    'Tiny House',
    'Beach House',
    'Floating Home',
    'Castle',
    'Igloo'
  ];

  final List<String> transactionType = ['Buy', 'Rent', 'Book', 'Office'];

  final List<String> amenities = [
    'Swimming Pool',
    'Gym',
    'Security',
    'Garden',
    'Clubhouse',
    'Free WiFi',
    'Playground',
    'BBQ Area',
    'Sauna',
    'Jacuzzi',
    'Library',
    'Business Center',
    'Cafeteria',
    'Air conditioning',
    'Kitchen',
    'Heating',
    'TV',
    'Washing machine',
    'Dryer',
    'Free parking on premises',
    'Dishwasher',
    'Hot tub',
    'Elevator',
    'Fireplace',
    'Balcony',
    'Patio',
    'Roof deck',
    'Pet-friendly',
    'Smart Home Technology',
    'Home Theater',
    'Wine Cellar',
    'Fitness Center',
    'Billiards Room',
    'Tennis Court',
    'Basketball Court',
    'Yoga Studio',
    'Spa',
    'Game Room',
    'Laundry Service',
    'Car Wash Service',
    'Bike Storage',
    'On-site Maintenance',
    '24-hour Security',
    'Valet Parking',
    'Shuttle Service',
    'Private Beach Access',
    'Furnished',
    'Walk-in Closets',
    'High-speed Internet',
    'Electric Vehicle Charging Stations'
  ];

  List<String> bedrooms = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];

  List<String> bathrooms = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];

  final ImagePicker _picker = ImagePicker();

  final RxBool imagesUploaded = false.obs;

  Rx<File?> videoFile = Rx<File?>(null);

  Future<void> selectVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      videoFile.value = File(pickedFile.path);
    }
  }

  Future<void> pickImage(bool isProfileImage) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final File image = File(pickedFile.path);

      if (!isProfileImage && displayImages.length < 10) {
        displayImages.add(image);
      } else if (isProfileImage) {
        houseProfileImage.value = image;
      } else {
        showToast('Cannot pick more than 10 display images', false);
        return;
      }
    }
  }

  void updateSelectedAmenities(String amenity, bool value) {
    if (value) {
      selectedAmenities.add(amenity);
    } else {
      selectedAmenities.remove(amenity);
    }
  }

  void deleteVideo() {
    videoFile.value = null;
  }

  void deleteProfileImage() {
    houseProfileImage.value = null;
  }

  void deleteDisplayImage(int index) {
    displayImages.removeAt(index);
  }

  void showConfirmationDialog() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Save'),
          content: const Text('Do you want to save this house?'),
          actions: [
            TextButton(
              onPressed: () async {
                int remaining =
                    subscriptionController.subscriptionRemaining.value;
                if (remaining < 1) {
                  Get.back();
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Subscription Required'),
                        content: const Text(
                          'You need to subscribe to post more houses.',
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Get.back();
                              Get.off(() => const PricingPage());
                            },
                            child: const Text('Subscribe Now'),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Get.back();
                  _saveHouse();
                }
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _saveHouse() async {
    var uploading = true.obs;

    if (_validateInputs()) {
      final Uri uri = Uri.parse(API.houseRegistration);

      try {
        final request = http.MultipartRequest('POST', uri)
          ..fields['user_id'] = _currentUser.user.userId.toString()
          ..fields['house_title'] = titleController.text
          ..fields['house_type'] = selectedHouseType.value
          ..fields['transaction_type'] = selectedTransactionType.value
          ..fields['house_description'] = houseDescriptionController.text
          ..fields['house_bedrooms'] = selectedBedroom.value
          ..fields['house_bathrooms'] = selectedBathroom.value
          ..fields['house_amenities'] = selectedAmenities.join(',')
          ..fields['rental_terms'] = rentalTermsController.text
          ..fields['contact_info'] = contactInfoController.text
          ..fields['house_price'] = priceController.text
          ..fields['total_ratings'] = ratingController.text
          ..fields['house_location'] = locationController.text;

        // Add video file
        if (videoFile.value != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'house_video',
            videoFile.value!.path,
          ));
        }

        // Add profile image
        if (houseProfileImage.value != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'house_profile_image',
            houseProfileImage.value!.path,
          ));
        }

        // Add display images
        for (int i = 0; i < displayImages.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
            'display_images[$i]',
            displayImages[i].path,
          ));
        }

        if (uploading.value) {
          Get.defaultDialog(
            title: 'Creating House',
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Uploading House to Cloud',
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
            barrierDismissible: false,
          );

          final response = await request.send();
          final String responseBody =
              await response.stream.transform(utf8.decoder).join();

          if (response.statusCode == 200) {
            if (responseBody.contains('House registration successful')) {
              await _adminHouseController.fetchAdminHouses();
              await subscriptionController
                  .decrementSubscriptionRemaining(_currentUser.user.userId);
              subscriptionController
                  .fetchSubscriptionRemaining(_currentUser.user.userId);
              showToast('House Created', true);
              notificationManager.newHouseNotifications();
              _clearTextFields();
              houseProfileImage.value = null;
              displayImages.clear();
              imagesUploaded.value = true;
              Get.back();
            } else {
              showToast('Server error: Unexpected response', false);
              Get.back();
            }
          } else {
            showToast('Server error: ${response.reasonPhrase}', false);
            Get.back();
          }
        }
      } catch (e) {
        showToast('An error occurred. Check your internet connection', false);
        Get.back();
      }
    }
  }

  void _clearTextFields() {
    titleController.clear();
    houseDescriptionController.clear();
    selectedHouseType.value = '';
    selectedBedroom.value = '';
    selectedBathroom.value = '';
    rentalTermsController.clear();
    contactInfoController.clear();
    priceController.clear();
    locationController.clear();
    houseProfileImage.value = null;
    displayImages.clear();
    ratingController.text = '0.0';
    selectedAmenities.clear();
    selectedTransactionType.value = '';
    videoFile.value = null;
  }

  void showToast(String message, bool success) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: success ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  bool _validateInputs() {
    if (titleController.text.isEmpty ||
        selectedHouseType.value.isEmpty ||
        selectedTransactionType.value.isEmpty ||
        houseDescriptionController.text.isEmpty ||
        selectedBedroom.value.isEmpty ||
        selectedBathroom.value.isEmpty ||
        selectedAmenities.isEmpty ||
        rentalTermsController.text.isEmpty ||
        contactInfoController.text.isEmpty ||
        priceController.text.isEmpty ||
        ratingController.text.isEmpty ||
        locationController.text.isEmpty) {
      showToast('Please fill in all required fields', false);

      return false;
    }

    if (houseProfileImage.value == null) {
      showToast('Please select a house profile image', false);
      Get.back();
      return false;
    }

    int minDisplayImages = 4;
    int maxDisplayImages = 10;

    if (displayImages.length < minDisplayImages - 2) {
      showToast('Please add at least two more display images', false);
      Get.back();
      return false;
    } else if (displayImages.length < minDisplayImages - 1) {
      showToast('Please add at least one more display image', false);
      Get.back();
      return false;
    } else if (displayImages.length > maxDisplayImages) {
      showToast('Please select up to $maxDisplayImages display images', false);
      Get.back();
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    titleController.dispose();
    houseDescriptionController.dispose();
    rentalTermsController.dispose();
    contactInfoController.dispose();
    priceController.dispose();
    locationController.dispose();
    super.onClose();
  }

  Widget buildImagePreview(bool isProfileImage, Function onDelete) {
    if (isProfileImage) {
      return houseProfileImage.value != null
          ? Stack(
              children: [
                Image.file(
                  houseProfileImage.value!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: GestureDetector(
                    onTap: () {
                      onDelete();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const SizedBox();
    } else {
      return displayImages.isNotEmpty
          ? Stack(
              children: [
                Image.file(
                  displayImages.first,
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: GestureDetector(
                    onTap: () {
                      onDelete();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : const SizedBox();
    }
  }

  Widget buildImageList(bool isDisplayImages, Function onDelete) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemCount: displayImages.length,
      itemBuilder: (context, index) {
        final image = displayImages[index];
        return Stack(
          alignment: Alignment.topRight,
          children: [
            Image.file(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200,
            ),
            GestureDetector(
              onTap: () {
                onDelete(index);
              },
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(6.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
