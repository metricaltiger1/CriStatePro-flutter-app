import 'package:cristatepro/admin/controllers/add_house.dart';
import 'package:cristatepro/admin/controllers/update_house.dart';
import 'package:cristatepro/admin/fragments/home/add_house_view.dart';
import 'package:cristatepro/admin/fragments/preview_house_mage.dart';
import 'package:cristatepro/house/house.dart';

import 'package:cristatepro/widgets/custom_appbar.dart';
import 'package:cristatepro/widgets/customtext.dart';
import 'package:cristatepro/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class UpdateHouseView extends StatelessWidget {
  final HouseModel houseData;
  final AddHouseController addHouseController = Get.put(AddHouseController());

  UpdateHouseView({super.key, required this.houseData});

  @override
  Widget build(BuildContext context) {
    final UpdateHouseController controller =
        Get.put(UpdateHouseController(houseData));
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(title: "Update House", centerTitle: false),
        titleTextStyle: const TextStyle(fontSize: 30),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: CustomText(
                    label: 'Title',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomTextField(
                  customTextFieldController: controller.titleController,
                  hintText: 'Enter house title (e.g., Comfy Family Home)',
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: CustomText(
                    label: 'Type',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedHouseType.value.isNotEmpty
                        ? controller.selectedHouseType.value
                        : null,
                    items:
                        addHouseController.houseTypes.map((String houseType) {
                      return DropdownMenuItem<String>(
                        value: houseType,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            houseType,
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedHouseType.value = newValue;
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Select house type',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 18.0, color: Colors.black),
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24.0,
                    isExpanded: true,
                  ),
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: CustomText(
                    label: 'Transaction Type',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedTransactionType.value.isNotEmpty
                        ? controller.selectedTransactionType.value
                        : null,
                    items: addHouseController.transactionType
                        .map((String transactionType) {
                      return DropdownMenuItem<String>(
                        value: transactionType,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            transactionType,
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedTransactionType.value = newValue;
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Select transaction type',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 18.0, color: Colors.black),
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24.0,
                    isExpanded: true,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: CustomText(
                    label: 'Description',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomTextField(
                  customTextFieldController:
                      controller.houseDescriptionController,
                  hintText:
                      'Enter a detailed description (e.g., Spacious living room)',
                  maxLines: 3,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: CustomText(
                    label: 'Bedrooms',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedBedroom.value.isNotEmpty
                        ? controller.selectedBedroom.value
                        : null,
                    items: addHouseController.bedrooms.map((String bedroom) {
                      return DropdownMenuItem<String>(
                        value: bedroom,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            bedroom,
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedBedroom.value = newValue;
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Select number of bedrooms',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 18.0, color: Colors.black),
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24.0,
                    isExpanded: true,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: CustomText(
                    label: 'Bathrooms',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedBathroom.value.isNotEmpty
                        ? controller.selectedBathroom.value
                        : null,
                    items: addHouseController.bathrooms.map((String bathroom) {
                      return DropdownMenuItem<String>(
                        value: bathroom,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            bathroom,
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedBathroom.value = newValue;
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Select number of bathrooms',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                    ),
                    style: const TextStyle(fontSize: 18.0, color: Colors.black),
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24.0,
                    isExpanded: true,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: CustomText(
                    label: 'Amenities',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Obx(
                  () => Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: addHouseController.amenities.map((amenity) {
                      final bool isSelected =
                          controller.selectedAmenities.contains(amenity);
                      return ElevatedButton(
                        onPressed: () {
                          controller.updateSelectedAmenities(
                              amenity, !isSelected);
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                            isSelected ? Colors.blue : Colors.grey,
                          ),
                        ),
                        child: Text(
                          amenity,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: CustomText(
                    label: 'Rental Terms',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomTextField(
                  customTextFieldController: controller.rentalTermsController,
                  hintText: 'Enter rental terms and conditions',
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: CustomText(
                    label: 'Contact Information',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomTextField(
                  customTextFieldController: controller.contactInfoController,
                  hintText: 'Enter contact info( e.g., Phone number, Email)',
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: CustomText(
                    label: 'Location',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: FlutterLocationPicker(
                    initPosition: location(controller.locationController.text),
                    urlTemplate:
                        'https://api.maptiler.com/maps/hybrid/{z}/{x}/{y}.jpg?key=HNnuSwg9R3dCSeL0qUr1',
                    initZoom: 11,
                    minZoomLevel: 5,
                    maxZoomLevel: 16,
                    trackMyPosition: true,
                    searchBarBackgroundColor: Colors.white,
                    selectedLocationButtonTextStyle:
                        const TextStyle(fontSize: 18),
                    mapLanguage: 'en',
                    selectLocationButtonLeadingIcon: const Icon(Icons.check),
                    onPicked: (pickedData) {
                      _updatePickedLocation(pickedData, controller);
                    },
                    onChanged: (pickedData) {
                      _updatePickedLocation(pickedData, controller);
                    },
                    showContributorBadgeForOSM: true,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: CustomText(
                    label: 'Price',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomTextField(
                  customTextFieldController: controller.priceController,
                  hintText: 'Enter house price',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: CustomText(
                    label: 'Rating',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RatingBar.builder(
                  initialRating: houseData.totalRatings.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    controller.ratingController.text = rating.toString();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => controller.pickImage(true),
                    child: const CustomText(
                      label: 'Pick House Profile Image',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      if (controller.houseProfileImage.value != null) {
                        Get.to(
                          () => ImagePreview(
                            images: [controller.houseProfileImage.value!],
                            initialIndex: 0,
                          ),
                        );
                      }
                    },
                    child: Obx(
                      () => controller.buildImagePreview(
                          true, controller.deleteProfileImage),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => controller.pickImage(false),
                    child: const CustomText(
                      label: 'Pick Display Images',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      if (controller.displayImages.isNotEmpty) {
                        Get.to(
                          () => ImagePreview(
                            images: controller.displayImages.toList(),
                            initialIndex: 0,
                          ),
                        );
                      }
                    },
                    child: Obx(
                      () => controller.buildImageList(
                          true, controller.deleteDisplayImage),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: controller.selectVideo,
                    child: const Text('Select Video (Optional)'),
                  ),
                ),
                Obx(() {
                  final video = controller.videoFile.value;
                  return video != null
                      ? Column(
                          children: [
                            VideoPlayerWidget(videoFile: video),
                            ElevatedButton(
                              onPressed: () {
                                controller.deleteVideo();
                              },
                              child: const Text('Delete Video'),
                            ),
                          ],
                        )
                      : const Padding(
                          padding: EdgeInsets.fromLTRB(20, 8, 5, 8),
                          child: Text('No Video Selected'),
                        );
                }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: controller.showConfirmationDialog,
                    child: const CustomText(
                      label: 'Save House',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LatLong location(String locationString) {
    List<String> parts = locationString.split(', ');
    if (parts.length >= 2) {
      double latitude = double.tryParse(parts[0]) ?? 0.0;
      double longitude = double.tryParse(parts[1]) ?? 0.0;
      return LatLong(latitude, longitude);
    } else {
      return const LatLong(0.0, 0.0);
    }
  }

  void _updatePickedLocation(
      PickedData pickedData, UpdateHouseController controller) {
    String locationString =
        '${pickedData.latLong.latitude}, ${pickedData.latLong.longitude}, ${pickedData.address}';
    controller.locationController.text = locationString;
  }
}
