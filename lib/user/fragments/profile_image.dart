import 'dart:io';
import 'dart:typed_data';

import 'package:cristatepro/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePreview extends StatelessWidget {
  final dynamic imageData;

  const ProfileImagePreview({super.key, required this.imageData});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (imageData is XFile) {
      imageWidget = Image.file(File(imageData.path));
    } else if (imageData is Uint8List) {
      imageWidget = Image.memory(imageData);
    } else {
      imageWidget = const Text('Get back and and Select an image');
    }

    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(
          title: "Profile Image Preview",
          centerTitle: false,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(child: imageWidget),
    );
  }
}
