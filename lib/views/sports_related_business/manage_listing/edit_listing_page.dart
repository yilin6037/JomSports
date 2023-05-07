import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/shared/constant/listing_type.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/form/image_picker.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/widget/item_form.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/widget/sports_facility_form.dart';

class EditListingPage extends StatelessWidget {
  EditListingPage({super.key});

  final ListingController listingController =
      Get.find(tag: 'listingController');

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        title: 'Edit Listing',
        role: Role.sportsRelatedBusiness,
        navIndex: 1,
        body: Column(
          children: [
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
                                buttonText: 'Save',
                                onSubmitted: listingController.editItem,
                              )
                            : SportsFacilityForm(
                                buttonText: 'Save',
                                onSubmitted: listingController.editSF,
                              ),
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }
}
