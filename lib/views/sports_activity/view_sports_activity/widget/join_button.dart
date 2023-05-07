import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/shared/constant/join_status.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/button/button.dart';

class JoinButton extends StatelessWidget {
  JoinButton({super.key});

  final SportsActivityController sportsActivityController =
      Get.find(tag: 'sportsActivityController');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<JoinStatus>(
      stream: sportsActivityController.isJoined(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final JoinStatus joinStatus = snapshot.data!;
          switch (joinStatus) {
            case JoinStatus.available:
              return Positioned(
                  left: (MediaQuery.of(context).size.width - 150) / 2,
                  bottom: 20,
                  child: SharedButton(
                    text: 'Join',
                    onPressed: () async {
                      await sportsActivityController.joinSportsActivity();
                      SharedDialog.alertDialog('You have joined',
                          'You have successfully joined this activity.');
                    },
                  ));
            case JoinStatus.joined:
              return Positioned(
                  left: (MediaQuery.of(context).size.width - 150) / 2,
                  bottom: 20,
                  child: SharedButton(
                    text: 'Leave',
                    danger: true,
                    onPressed: () async {
                      await sportsActivityController.leaveSportsActivity();
                      SharedDialog.alertDialog('You have leave',
                          'You have successfully leave this activity.');
                    },
                  ));
            case JoinStatus.full:
              return Positioned(
                left: (MediaQuery.of(context).size.width - 150) / 2,
                bottom: 20,
                child: SharedButton(
                  disable: true,
                  text: 'FULL',
                  onPressed: () {},
                ),
              );
            case JoinStatus.unavailable:
              return Positioned(
                left: (MediaQuery.of(context).size.width - 150) / 2,
                bottom: 20,
                child: SharedButton(
                  disable: true,
                  text: 'UNAVAILABLE',
                  onPressed: () {},
                ),
              );
          }
        } else {
          return Positioned(
            left: (MediaQuery.of(context).size.width - 150) / 2,
            bottom: 20,
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
