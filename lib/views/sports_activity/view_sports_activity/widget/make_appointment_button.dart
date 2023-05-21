import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/controllers/sports_related_business_controller.dart';
import 'package:jomsports/shared/constant/join_status.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/views/sports_activity/make_appointment/make_appointment_page.dart';

class MakeAppointmentButton extends StatelessWidget {
  MakeAppointmentButton({super.key});

  final SportsActivityController sportsActivityController =
      Get.find(tag: 'sportsActivityController');

  final ListingController listingController =
      Get.find(tag: 'listingController');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<JoinStatus>(
        stream: sportsActivityController.isJoined(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final JoinStatus joinStatus = snapshot.data!;
            if (joinStatus == JoinStatus.joined) {
              return SharedButton(
                onPressed: () async {
                  final SportsRelatedBusinessController
                      sportsRelatedBusinessController = Get.put(
                          tag: 'sportsRelatedBusinessController',
                          SportsRelatedBusinessController());
                  await sportsRelatedBusinessController.initMap();
                  listingController.selectedSaID =
                      sportsActivityController.selectedSportsActivity!.saID;
                  Get.to(() => MakeAppointmentPage(
                        makeAppointment: true,
                      ));
                },
                text: 'Make Appointment',
                fontSize: 12,
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('- No active appointment made -'),
              );
            }
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
