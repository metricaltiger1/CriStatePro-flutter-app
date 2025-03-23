import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:cristatepro/admin/fragments/preview_house_mage.dart';
import 'package:cristatepro/widgets/custom_appbar.dart';
import 'package:cristatepro/widgets/customtext.dart';
import 'package:cristatepro/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:cristatepro/admin/controllers/add_house.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

class AddHouseView extends StatelessWidget {
  final AddHouseController _controller = Get.put(AddHouseController());

  AddHouseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(title: "Add House", centerTitle: false),
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
                  customTextFieldController: _controller.titleController,
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
                    value: _controller.selectedHouseType.value.isNotEmpty
                        ? _controller.selectedHouseType.value
                        : null,
                    items: _controller.houseTypes.map((String houseType) {
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
                        _controller.selectedHouseType.value = newValue;
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
                    value: _controller.selectedTransactionType.value.isNotEmpty
                        ? _controller.selectedTransactionType.value
                        : null,
                    items: _controller.transactionType
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
                        _controller.selectedTransactionType.value = newValue;
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
                      _controller.houseDescriptionController,
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
                    value: _controller.selectedBedroom.value.isNotEmpty
                        ? _controller.selectedBedroom.value
                        : null,
                    items: _controller.bedrooms.map((String bedroom) {
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
                        _controller.selectedBedroom.value = newValue;
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
                    value: _controller.selectedBathroom.value.isNotEmpty
                        ? _controller.selectedBathroom.value
                        : null,
                    items: _controller.bathrooms.map((String bathroom) {
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
                        _controller.selectedBathroom.value = newValue;
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
                    children: _controller.amenities.map((amenity) {
                      final bool isSelected =
                          _controller.selectedAmenities.contains(amenity);
                      return ElevatedButton(
                        onPressed: () {
                          _controller.updateSelectedAmenities(
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
                    label: 'Terms and Conditions',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomTextField(
                  customTextFieldController: _controller.rentalTermsController,
                  hintText: 'Enter rental/sale/booking terms and conditions',
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
                  customTextFieldController: _controller.contactInfoController,
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
                      _updatePickedLocation(pickedData);

                      // print(pickedData.latLong.latitude);
                      // print(pickedData.latLong.longitude);
                      // print("Address: ${pickedData.address}");
                      // print("Address Data: ${pickedData.addressData}");
                    },
                    onChanged: (pickedData) {
                      _updatePickedLocation(pickedData);
                      // print(pickedData.latLong.latitude);
                      // print(pickedData.latLong.longitude);
                      // print(pickedData.address);
                      // print(pickedData.addressData);
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
                  customTextFieldController: _controller.priceController,
                  hintText: 'Enter house price',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  child: CustomText(
                    label: 'Initial Rating',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RatingBar.builder(
                  initialRating: 0,
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
                    _controller.ratingController.text = rating.toString();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _controller.pickImage(true),
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
                      if (_controller.houseProfileImage.value != null) {
                        Get.to(
                          () => ImagePreview(
                            images: [_controller.houseProfileImage.value!],
                            initialIndex: 0,
                          ),
                        );
                      }
                    },
                    child: Obx(
                      () => _controller.buildImagePreview(
                          true, _controller.deleteProfileImage),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _controller.pickImage(false),
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
                      if (_controller.displayImages.isNotEmpty) {
                        Get.to(
                          () => ImagePreview(
                            images: _controller.displayImages.toList(),
                            initialIndex: 0,
                          ),
                        );
                      }
                    },
                    child: Obx(
                      () => _controller.buildImageList(
                          true, _controller.deleteDisplayImage),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _controller.selectVideo,
                    child: const Text('Select Video (Optional)'),
                  ),
                ),
                Obx(() {
                  final video = _controller.videoFile.value;
                  return video != null
                      ? Column(
                          children: [
                            VideoPlayerWidget(videoFile: video),
                            ElevatedButton(
                              onPressed: () {
                                _controller.deleteVideo();
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
                    onPressed: _controller.showConfirmationDialog,
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

  void _updatePickedLocation(PickedData pickedData) {
    String locationString =
        '${pickedData.latLong.latitude}, ${pickedData.latLong.longitude}, ${pickedData.address}';
    _controller.locationController.text = locationString;
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;

  const VideoPlayerWidget({super.key, required this.videoFile});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
        });
      });
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
      allowedScreenSleep: false,
      allowFullScreen: true,
      showControls: true,
      placeholder: Center(
        child: Lottie.asset(
          'assets/progressbar.json',
          width: 60,
          height: 60,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Chewie(controller: _chewieController),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
    if (widget.videoFile.existsSync()) {
      widget.videoFile.deleteSync();
    }
  }
}
