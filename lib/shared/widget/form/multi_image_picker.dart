import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class SharedMultiImagePicker extends StatelessWidget {
  SharedMultiImagePicker({super.key, required this.onSelectImage});

  List<XFile> images = [];
  RxList<String> imagePaths = RxList<String>();
  final Function(List<XFile>) onSelectImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(() => CarouselSlider.builder(
            itemCount: imagePaths.length + 1,
            itemBuilder: (context, index, realIndex) {
              if (index == 0) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: IconButton(
                    icon: const Icon(Icons.photo_library_outlined),
                    onPressed: pickImage,
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(File(imagePaths.elementAt(index - 1)),
                      fit: BoxFit.cover, width: double.infinity),
                );
              }
            },
            options: CarouselOptions(
              enableInfiniteScroll: false,
            ))),
      ],
    );
  }

  Future<void> pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    if (await Permission.storage.request().isGranted) {
      final List<XFile> imagesPicked =
          await imagePicker.pickMultiImage(maxWidth: 600);
      if (imagesPicked.isNotEmpty) {
        images = imagesPicked.map((e) => XFile(e.path)).toList();
        imagePaths.value = images.map((e) => e.path).toList();
        onSelectImage(images);
      } else {
        SharedDialog.alertDialog(
            'Operation Failed', 'No photo received. Please try again.');
      }
    } else {
      SharedDialog.alertDialog('Operation Failed',
          'Permission is dennied. Try Again with permission access.');
    }
  }
}
