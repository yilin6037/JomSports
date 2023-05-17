import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/models/appointment.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/shared/constant/appointment_status.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/view_sports_activity/widget/cancel_button.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/view_sports_activity/widget/participant_list.dart';

class ViewSportsActivityPage extends StatelessWidget {
  ViewSportsActivityPage({super.key});

  final SportsActivityController sportsActivityController =
      Get.put(tag: 'sportsActivityController', SportsActivityController());

  @override
  Widget build(BuildContext context) {
    if (sportsActivityController.selectedSportsActivity == null) {
      SharedDialog.errorDialog();
      Get.back();
    }
    SportsActivity sportsActivity =
        sportsActivityController.selectedSportsActivity!;
    return DefaultScaffold(
      title: '${sportsActivity.sportsType.sportsName} Activity Detail',
      role: Role.sportsRelatedBusiness,
      navIndex: 1,
      scrollable: false,
      body: Stack(children: [
        SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                children: [
                  //icon
                  Image.asset(
                    sportsActivity.sportsType.mapMarker,
                    height: 100,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Column(
                      children: [
                        //datetime
                        Row(
                          children: [
                            const Icon(Icons.access_time),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(sportsActivity.dateTime)
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //location
                        Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Text(
                              sportsActivity.address,
                              softWrap: true,
                            ))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            StreamBuilder<List<Appointment>>(
                                stream: sportsActivityController
                                    .getAppointmentListBySaID(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const Center(
                                        child: Text('Something went wrong'));
                                  }
                                  if (snapshot.hasData) {
                                    final appointmentList = snapshot.data!;
                                    bool hasAppointment = false;
                                    return Expanded(
                                      child: LimitedBox(
                                        maxHeight: 250,
                                        child: ListView.builder(
                                            itemCount: appointmentList.length,
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            physics: const ScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              if (appointmentList[index]
                                                      .status ==
                                                  AppointmentStatus
                                                      .appointmentMade) {
                                                hasAppointment = true;
                                              }
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  FutureBuilder<String>(
                                                    future:
                                                        sportsActivityController
                                                            .getSportsFacilityName(
                                                                appointmentList[
                                                                        index]
                                                                    .listingID),
                                                    builder: (context,
                                                            snapshot) =>
                                                        Text(snapshot.data ??
                                                            ''),
                                                  ),
                                                  Text(
                                                      '${appointmentList[index].slot}:00 - ${appointmentList[index].slot}:59'),
                                                  Text(
                                                    appointmentList[index]
                                                        .status
                                                        .statusText,
                                                    style: const TextStyle(
                                                        color: Color(ColorConstant
                                                            .notSelectedTextColor)),
                                                  )
                                                ],
                                              );
                                            }),
                                        //make another appointment button
                                      ),
                                    );
                                  } else {
                                    return const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                })
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  //description
                  Text(sportsActivity.description),

                  const Divider(),

                  //participants
                  ParticipantListWidget(),

                  const Divider(),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
        //button
        CancelButton(),
      ]),
    );
  }
}
