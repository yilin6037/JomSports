import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/controllers/sports_related_business_controller.dart';
import 'package:jomsports/models/appointment.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/shared/constant/appointment_status.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/sports_activity/make_appointment/make_appointment_page.dart';
import 'package:jomsports/views/sports_activity/view_sports_activity/widget/comment.dart';
import 'package:jomsports/views/sports_activity/view_sports_activity/widget/join_button.dart';
import 'package:jomsports/views/sports_activity/view_sports_activity/widget/make_appointment_button.dart';
import 'package:jomsports/views/sports_activity/view_sports_activity/widget/participant_list.dart';

class ViewSportsActivityPage extends StatelessWidget {
  ViewSportsActivityPage({super.key});

  final SportsActivityController sportsActivityController =
      Get.put(tag: 'sportsActivityController', SportsActivityController());

  final ListingController listingController =
      Get.put(tag: 'listingController', ListingController());

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
      role: Role.sportsLover,
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
                                    if (appointmentList.isEmpty) {
                                      return MakeAppointmentButton();
                                    }

                                    return Expanded(
                                      child: LimitedBox(
                                        maxHeight: 250,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListView.builder(
                                                itemCount:
                                                    appointmentList.length,
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                physics: const ScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      FutureBuilder<String>(
                                                        future: sportsActivityController
                                                            .getSportsFacilityName(
                                                                appointmentList[
                                                                        index]
                                                                    .listingID),
                                                        builder: (context,
                                                                snapshot) =>
                                                            Text(
                                                                snapshot.data ??
                                                                    ''),
                                                      ),
                                                      Text(
                                                          '${appointmentList[index].slot}:00 - ${appointmentList[index].slot}:59'),
                                                      Text(
                                                        appointmentList[index]
                                                            .status
                                                            .statusText,
                                                        style: const TextStyle(
                                                            color: Color(
                                                                ColorConstant
                                                                    .notSelectedTextColor)),
                                                      )
                                                    ],
                                                  );
                                                }),
                                            if (appointmentList.isNotEmpty &&
                                                appointmentList[0].status !=
                                                    AppointmentStatus
                                                        .appointmentMade)
                                              MakeAppointmentButton(),
                                          ],
                                        ),
                                        //make another appointment
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

                  //comment
                  CommentWidget(),

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
        JoinButton(),
      ]),
    );
  }
}
