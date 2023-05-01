import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:permission_handler/permission_handler.dart';

class SharedImagePicker extends StatelessWidget {
  SharedImagePicker(
      {super.key,
      required this.image,
      required this.onSelectImage,
      this.imageUrl});

  XFile image;
  RxString imagePath = RxString('');
  RxString imageUrlObs = RxString('');
  final Function(XFile) onSelectImage;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    imagePath.value = image.path;
    if(imageUrl!=null){
      imageUrlObs.value = imageUrl!;
    }
    return Column(children: [
      Container(
        width: 150,
        height: 150,
        alignment: Alignment.center,
        decoration:
            BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
        child: Obx(
          () => imagePath.value != ''
              ? Image.file(File(imagePath.value),
                  fit: BoxFit.cover, width: double.infinity)
              : (imageUrlObs.value.isNotEmpty
                  ? buildImage(imageUrlObs.value)
                  : const Text(
                      'No Profile Picture Uploaded',
                      textAlign: TextAlign.center,
                    )),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      SharedButton(onPressed: pickImage, text: 'Choose Photo')
    ]);
  }

  Future<void> pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    if (await Permission.storage.request().isGranted) {
      final XFile? imagePicked = await imagePicker.pickImage(
          source: ImageSource.gallery, maxWidth: 600);
      if (imagePicked != null) {
        image = XFile(imagePicked.path);
        imagePath.value = image.path;
        onSelectImage(image);
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

Widget buildImage(String? data) {
  return ClipRect(
    child: Material(
      color: Colors.transparent,
      child: Ink.image(
        image: NetworkImage(data.toString()),
        fit: BoxFit.cover,
        width: 150,
        height: 150,
        child: const InkWell(/* onTap: onClicked */),
      ),
    ),
  );
}
