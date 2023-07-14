import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/controllers/sports_related_business_controller.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_map.dart';
import 'package:jomsports/views/sports_activity/make_appointment/view_sports_related_business_page.dart';
import 'package:map_location_picker/map_location_picker.dart';

class MakeAppointmentPage extends StatelessWidget {
  MakeAppointmentPage({super.key, this.makeAppointment = false});

  final bool makeAppointment;

  final SportsRelatedBusinessController sportsRelatedBusinessController =
      Get.put(
          tag: 'sportsRelatedBusinessController',
          SportsRelatedBusinessController());

  @override
  Widget build(BuildContext context) {
    if (makeAppointment) {
      final ListingController listingController =
          Get.find(tag: 'listingController');
      listingController.isMakeAppointment = makeAppointment;
      if (listingController.selectedSaID == null) {
        SharedDialog.errorDialog();
        Get.back();
      }
    }
    return Obx(() {
      var currentLatLng = LatLng(sportsRelatedBusinessController.lat.value,
              sportsRelatedBusinessController.lon.value)
          .obs;
      return MapScaffold(
        title: 'Choose Provider for Appointment',
        role: Role.sportsLover,
        navIndex: 1,
        currentLatLng: currentLatLng.value,
        stream: sportsRelatedBusinessController.getSportsRelatedBusinessMarkerList(
            onTap: (sportsRelatedBusiness) {
              bool isInit = sportsRelatedBusinessController
                  .initSRB(sportsRelatedBusiness);
              if (isInit) {
                Get.to(() => ViewSportsRelatedBusinessPage());
              }
            },
            isSFOnly: true),
        children: const [
          Positioned(
            top: 0,
            left: 0,
            child: BackButton(),
          )
        ],
      );
    });
  }
}
