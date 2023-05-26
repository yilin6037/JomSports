import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/shared/constant/listing_type.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/create_listing_page.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/widget/item_list.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/widget/listing_type_button.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/widget/sports_facility_list.dart';

class ListingPage extends StatelessWidget {
  ListingPage({super.key});

  final ListingController listingController =
      Get.put(tag: 'listingController', ListingController());

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: 'Manage Listing',
      role: Role.sportsRelatedBusiness,
      navIndex: 1,
      scrollable: false,
      back: false,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 50, left: 20, right: 20, bottom: 70),
              child: Card(
                child: SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => listingController.listingChoice.value ==
                              ListingType.item
                          ? ItemList()
                          : SportsFacilityList(),
                    )),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListingTypeButton(
                onPressed: () {},
              ),
            ),
          ),
          Positioned(
            left: (MediaQuery.of(context).size.width - 150) / 2,
            bottom: 20,
            child: SharedButton(
              text: 'Add',
              onPressed: () {
                listingController.initItemForm();
                listingController.initSFForm();
                Get.to(() => CreateListingPage());
              },
            ),
          ),
        ],
      ),
    );
  }
}
