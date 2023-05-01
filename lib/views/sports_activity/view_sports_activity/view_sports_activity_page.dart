import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/models/user.dart';
import 'package:jomsports/shared/constant/join_status.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/sports_activity/view_sports_activity/widget/comment.dart';
import 'package:jomsports/views/sports_activity/view_sports_activity/widget/join_button.dart';
import 'package:jomsports/views/sports_activity/view_sports_activity/widget/participant_list.dart';

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
