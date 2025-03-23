import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cristatepro/admin/controllers/admin_house_controller.dart';
import 'package:cristatepro/admin/fragments/houses/admin_house_list_view.dart';
import 'package:cristatepro/api_connection/api_connection.dart';
import 'package:cristatepro/house/house.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';

class UpdateHouseController extends GetxController {
  final HouseModel houseData;

  UpdateHouseController(this.houseData);
  final AdminHouseController houseController = Get.find();

  final TextEditingController titleController = TextEditingController();
  final RxString selectedHouseType = RxString('');
  final TextEditingController houseDescriptionController =
      TextEditingController();
  final RxString selectedBedroom = RxString('');
  final RxString selectedTransactionType = RxString('');
  final RxString selectedBathroom = RxString('');
  final RxList<String> selectedAmenities = <String>[].obs;

  final TextEditingController rentalTermsController = TextEditingController();
  final TextEditingController contactInfoController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final Rx<File?> houseProfileImage = Rx<File?>(null);
  final RxList<File> displayImages = <File>[].obs;
  final TextEditingController ratingController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final RxBool imagesUploaded = false.obs;
  final RxBool loading = false.obs;

  // Add property to hold selected video file
  final Rx<File?> videoFile = Rx<File?>(null);

  // Add method to select a video
  Future<void> selectVideo() async {
    final XFile? pickedVideo = await _picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedVideo != null) {
      final File video = File(pickedVideo.path);
      videoFile.value = video;
    }
  }

  // Add method to delete the selected video
  void deleteVideo() {
    videoFile.value = null;
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

  void deleteProfileImage() {
    houseProfileImage.value = null;
  }

  void deleteDisplayImage(int index) {
    displayImages.removeAt(index);
  }

  @override
  void onInit() {
    super.onInit();
    initializeData(houseData);
  }

  Future<void> initializeData(HouseModel houseData) async {
    titleController.text = houseData.houseTitle;
    houseDescriptionController.text = houseData.houseDescription;
    selectedHouseType.value = houseData.houseType;
    selectedTransactionType.value = houseData.transactionType;
    selectedBedroom.value = houseData.houseBedrooms.toString();
    selectedBathroom.value = houseData.houseBathrooms.toString();
    selectedAmenities.value = houseData.houseAmenities.split(',');
    rentalTermsController.text = houseData.rentalTerms;
    contactInfoController.text = houseData.contactInfo;
    priceController.text = houseData.housePrice.toString();
    locationController.text = houseData.houseLocation;
    ratingController.text = houseData.totalRatings.toString();

    final profileImageUrl = API.profilemage + houseData.houseProfileImage;
    final profileImageResponse = await http.get(Uri.parse(profileImageUrl));
    if (profileImageResponse.statusCode == 200) {
      final profileImageBytes = profileImageResponse.bodyBytes;
      final profileImageFile = await _saveImageToTemporaryDirectory(
          profileImageBytes, 'profile_image.jpg');
      houseProfileImage.value = profileImageFile;
    }

    for (int i = 0; i < houseData.displayImages.length; i++) {
      final image = houseData.displayImages[i];
      final displayImageUrl = API.displayImages + image;
      final displayImageResponse = await http.get(Uri.parse(displayImageUrl));
      if (displayImageResponse.statusCode == 200) {
        final displayImageBytes = displayImageResponse.bodyBytes;
        final displayImageFile = await _saveImageToTemporaryDirectory(
            displayImageBytes, 'display_image_$i.jpg');
        displayImages.add(displayImageFile);
      }
    }

    if (houseData.videoUrl.isNotEmpty) {
      final videoUrl = API.houseVideo + houseData.videoUrl;
      final cacheManager = DefaultCacheManager();
      FileInfo? fileInfo = await cacheManager.getFileFromCache(videoUrl);
      fileInfo ??= await cacheManager.downloadFile(videoUrl);
      final videoFile = fileInfo.file;
      this.videoFile.value = videoFile;
    }
  }

  Future<File> _saveImageToTemporaryDirectory(
      Uint8List imageBytes, String fileName) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final tempFile = File('$tempPath/$fileName');
    await tempFile.writeAsBytes(imageBytes);
    return tempFile;
  }

  Future<void> saveChanges() async {
    loading.value = true;
    Get.dialog(
      AlertDialog(
        title: const Center(child: Text('Updating House')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/progressbar.json',
              width: 60,
              height: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'Updating House hold on...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    if (_validateInputs()) {
      final Uri uri = Uri.parse(API.houseUpdate);

      try {
        final request = http.MultipartRequest('POST', uri)
          ..fields['house_id'] = houseData.houseId.toString()
          ..fields['house_title'] = titleController.text
          ..fields['transaction_type'] = selectedTransactionType.value
          ..fields['house_description'] = houseDescriptionController.text
          ..fields['house_type'] = selectedHouseType.value
          ..fields['house_bedrooms'] = selectedBedroom.value
          ..fields['house_bathrooms'] = selectedBathroom.value
          ..fields['house_amenities'] = selectedAmenities.join(',')
          ..fields['rental_terms'] = rentalTermsController.text
          ..fields['contact_info'] = contactInfoController.text
          ..fields['house_price'] = priceController.text
          ..fields['house_location'] = locationController.text
          ..fields['new_rating'] = ratingController.text;

        if (houseProfileImage.value != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'house_profile_image',
            houseProfileImage.value!.readAsBytesSync(),
            filename: 'profile_image.jpg',
          ));
        }

        for (int i = 0; i < displayImages.length; i++) {
          request.files.add(http.MultipartFile.fromBytes(
            'display_images[]',
            displayImages[i].readAsBytesSync(),
            filename: 'display_image_$i.jpg',
          ));
        }

        if (videoFile.value != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'house_video',
            videoFile.value!.path,
          ));
        }

        final response = await request.send();
        final String responseBody =
            await response.stream.transform(utf8.decoder).join();

        if (response.statusCode == 200) {
          var responseData = jsonDecode(responseBody);
          if (responseData['success']) {
            await houseController.fetchAdminHouses();
            Fluttertoast.showToast(msg: 'House data updated successfully');
            Get.offAll(() => AdminHouseListView());
          } else {
            Fluttertoast.showToast(msg: 'Failed to update house data');
            Get.back();
          }
        } else {
          Fluttertoast.showToast(msg: 'Failed to update house data');
          Get.back();
        }
      } catch (e) {
        Fluttertoast.showToast(msg: 'An error occurred...Check your internet');
        Get.back();
      } finally {
        loading.value = false;
        clearTemporaryStorage();
      }
    } else {
      loading.value = false;
    }
  }

  void showConfirmationDialog() {
    Get.defaultDialog(
      title: 'Confirmation',
      content: const Text('Are you sure you want to save changes?'),
      confirm: ElevatedButton(
        onPressed: () {
          saveChanges();
        },
        child: const Text('Save'),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: const Text('Cancel'),
      ),
    );
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
        houseDescriptionController.text.isEmpty ||
        selectedBedroom.value.isEmpty ||
        selectedTransactionType.value.isEmpty ||
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
      return false;
    }

    int minDisplayImages = 4;
    int maxDisplayImages = 10;

    if (displayImages.length < minDisplayImages - 2) {
      showToast('Please add at least two more display images', false);
      return false;
    } else if (displayImages.length < minDisplayImages - 1) {
      showToast('Please add at least one more display image', false);
      return false;
    } else if (displayImages.length > maxDisplayImages) {
      showToast('Please select up to $maxDisplayImages display images', false);
      return false;
    }

    return true;
  }

  void clearTemporaryStorage() async {
    final tempDir = await getTemporaryDirectory();
    tempDir.delete(recursive: true);
  }

  @override
  void onClose() {
    titleController.dispose();
    houseDescriptionController.dispose();
    rentalTermsController.dispose();
    contactInfoController.dispose();
    priceController.dispose();
    locationController.dispose();
    ratingController.dispose();
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
