import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/shared/widget/button/button.dart';

class SharedDialog {
  static void alertDialog(String title, String message) {
    Get.defaultDialog(
        title: title,
        middleText: message,
        confirm: SharedButton(
            onPressed: () {
              Get.back();
            },
            text: 'Ok'));
  }

  static void errorDialog() {
    alertDialog('Error', 'Something went wrong!');
  }

  static void directDialog(String title, String message, Widget page) {
    Get.defaultDialog(
        title: title,
        middleText: message,
        confirm: SharedButton(
            onPressed: () {
              Get.off(() => page);
            },
            text: 'Ok'));
  }

  static void confirmationDialog(
      {String title = 'Confirm Dialog',
      String message = 'Are you sure?',
      required Function onOK,
      required Function onCancel}) {
    Get.defaultDialog(
      title: title,
      middleText: message,
      confirm: SharedButton(
        onPressed: () {
          onOK();
          Get.back();
        },
        text: 'Ok',
        danger: true,
      ),
      cancel: SharedButton(
          onPressed: () {
            onCancel();
            Get.back();
          },
          text: 'Cancel'),
    );
  }
}
