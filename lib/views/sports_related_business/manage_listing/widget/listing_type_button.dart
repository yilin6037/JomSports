import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/shared/constant/listing_type.dart';
import 'package:jomsports/shared/widget/button/bool_button.dart';

class ListingTypeButton extends StatelessWidget {
  ListingTypeButton({super.key, required this.onPressed});

  final ListingController listingController =
      Get.find(tag: 'listingController');
  
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SharedBoolButton(
                      text: 'Item',
                      tapped: listingController.listingChoice.value == ListingType.item,
                      width: MediaQuery.of(context).size.width * 0.4,
                      onPressed: () {
                        listingController.initItemForm();
                        onPressed();
                        listingController.listingChoice.value = ListingType.item;
                      },
                    ),
                    SharedBoolButton(
                      text: 'Sports Facility',
                      tapped: listingController.listingChoice.value == ListingType.facility,
                      width: MediaQuery.of(context).size.width * 0.4,
                      onPressed: () {
                        listingController.initSFForm();
                        onPressed();
                        listingController.listingChoice.value = ListingType.facility;
                      },
                    ),
                  ],));
  }
}