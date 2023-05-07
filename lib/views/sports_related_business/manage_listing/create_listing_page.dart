import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/shared/constant/listing_type.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/form/image_picker.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/widget/item_form.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/widget/listing_type_button.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/widget/sports_facility_form.dart';

class CreateListingPage extends StatelessWidget {
  CreateListingPage({super.key});

  final ListingController listingController =
      Get.find(tag: 'listingController');

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        title: 'Create Listing',
        role: Role.sportsRelatedBusiness,
        navIndex: 1,
        body: Column(
          children: [
            ListingTypeButton(
              onPressed: () {
                listingController.initItemForm();
                listingController.initSFForm();
              },
            ),
            Card(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    children: [
                      SharedImagePicker(
                        image: listingController.listingPicture,
                        onSelectImage: listingController.onSelectListingPicture,
                        imageUrl: listingController.listingPictureUrl,
                      ),
                      Obx(
                        () => listingController.listingChoice.value ==
                                ListingType.item
                            ? ItemForm(
                                buttonText: 'Add',
                                onSubmitted: listingController.addItem,
                                formKey: listingController.addItemFormKey,
                              )
                            : SportsFacilityForm(
                                buttonText: 'Add',
                                onSubmitted: listingController.addSF,
                                formKey: listingController.addFacilityFormKey,
                              ),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}
