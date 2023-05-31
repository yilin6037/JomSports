import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/controllers/sports_related_business_controller.dart';
import 'package:jomsports/models/appointment.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/view_sports_activity/view_sports_activity_page.dart';

import '../../sports_related_business/manage_listing/availability_page.dart';

class SportsRelatedBusinessHome extends StatelessWidget {
  SportsRelatedBusinessHome({super.key});

  final SportsRelatedBusinessController sportsRelatedBusinessController =
      Get.put(
          tag: 'sportsRelatedBusinessController',
          SportsRelatedBusinessController());

  final ListingController listingController =
      Get.put(tag: 'listingController', ListingController());

  final SportsActivityController sportsActivityController =
      Get.put(tag: 'sportsActivityController', SportsActivityController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Today\'s Appointment',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        StreamBuilder<List<Appointment>>(
          stream: sportsRelatedBusinessController.getUpcomingAppointment(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            } else if (snapshot.hasData) {
              final appointmentList = snapshot.data!;
              if (appointmentList.isEmpty) {
                return Card(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Text(
                        '- No upcoming appointment -',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }
              return Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: appointmentList.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) => Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await listingController.initAvailability(
                                appointmentList[index].listingID);
                            Get.to(() => AvailabilityPage());
                          },
                          child: ListTile(
                            title: FutureBuilder<String>(
                              future: sportsRelatedBusinessController
                                  .getSportsFacilityName(
                                      appointmentList[index].listingID),
                              builder: (context, snapshot) =>
                                  Text(snapshot.data ?? ''),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.access_time),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        '${appointmentList[index].slot}:00 - ${appointmentList[index].slot}:59'),
                                  ],
                                ),
                                Text(
                                  appointmentList[index].status.statusText,
                                  style: const TextStyle(
                                      color: Color(
                                          ColorConstant.notSelectedTextColor)),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.sports_handball_outlined),
                              onPressed: () async {
                                await sportsActivityController
                                    .initSportsActivity(
                                        appointmentList[index].saID);
                                listingController.selectedAppointmentID =
                                    appointmentList[index].appointmentID;
                                Get.to(() => ViewSportsActivityPage());
                              },
                            ),
                            enabled: appointmentList[index].slot >
                                DateTime.now().hour,
                          ),
                        ),
                        const Divider()
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
      ],
    );
  }
}
