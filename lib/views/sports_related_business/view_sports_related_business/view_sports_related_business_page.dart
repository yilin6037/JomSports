import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/controllers/sports_related_business_controller.dart';
import 'package:jomsports/models/sports_related_business.dart';
import 'package:jomsports/shared/constant/asset.dart';
import 'package:jomsports/shared/constant/listing_type.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/sports_related_business/view_sports_related_business/widget/item_list.dart';
import 'package:jomsports/views/sports_related_business/view_sports_related_business/widget/listing_type_button.dart';
import 'package:jomsports/views/sports_related_business/view_sports_related_business/widget/sports_facility_list.dart';

class ViewSportsRelatedBusinessPage extends StatelessWidget {
  ViewSportsRelatedBusinessPage({super.key});

  final SportsRelatedBusinessController sportsRelatedBusinessController =
      Get.find(tag: 'sportsRelatedBusinessController');

  final ListingController listingController =
      Get.find(tag: 'listingController');

  @override
  Widget build(BuildContext context) {
    if (sportsRelatedBusinessController.selectedSRB == null) {
      SharedDialog.errorDialog();
      Get.back();
    }
    SportsRelatedBusiness sportsRelatedBusiness =
        sportsRelatedBusinessController.selectedSRB!;
    return DefaultScaffold(
      title: sportsRelatedBusiness.name,
      role: sportsRelatedBusinessController.userController.currentUser.userType,
      navIndex: sportsRelatedBusinessController.initIndex(),
      body: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              //pic
              sportsRelatedBusiness.profilePictureUrl != null &&
                      sportsRelatedBusiness.profilePictureUrl!.isNotEmpty
                  ? ClipRect(
                      child: Material(
                        color: Colors.transparent,
                        child: Ink.image(
                            image: NetworkImage(
                                sportsRelatedBusiness.profilePictureUrl!),
                            fit: BoxFit.contain,
                            height: 100,
                            child: const InkWell()),
                      ),
                    )
                  : Image.asset(
                      AssetConstant.shop,
                      height: 100,
                    ),

              //phone no
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.phone),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Text(
                      sportsRelatedBusiness.phoneNo,
                      softWrap: true,
                    ))
                  ],
                ),
              ),

              //address
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Text(
                      sportsRelatedBusiness.address,
                      softWrap: true,
                    ))
                  ],
                ),
              ),

              const Divider(),

              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ListingTypeButton(
                  onPressed: () {},
                ),
              ),

              ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.40),
                child: SingleChildScrollView(
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
            ],
          ),
        ),
      ),
    );
  }
}
