import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/availability_page.dart';

class CancelButton extends StatelessWidget {
  CancelButton({super.key});

  final SportsActivityController sportsActivityController =
      Get.find(tag: 'sportsActivityController');
  final ListingController listingController =
      Get.find(tag: 'listingController');

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: (MediaQuery.of(context).size.width - 150) / 2,
        bottom: 20,
        child: SharedButton(
          text: 'Cancel',
          danger: true,
          onPressed: () {
            SharedDialog.confirmationDialog(
                message: 'Are you sure you want to cancel this appointment?',
                onOK: () async {
                  await listingController.cancelAppointment();
                  SharedDialog.directDialog(
                     'Success', 'Appointment is successfully canceled', AvailabilityPage());
                },
                onCancel: () {});
          },
        ));
  }
}
