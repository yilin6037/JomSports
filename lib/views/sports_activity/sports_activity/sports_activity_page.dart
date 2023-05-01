import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/button/bool_button.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_map.dart';
import 'package:jomsports/views/sports_activity/organize_sports_activity/organize_sports_activity_page.dart';

class SportsActivityPage extends StatelessWidget {
  SportsActivityPage({super.key});

  final SportsActivityController sportsActivityController =
      Get.put(tag: 'sportsActivityController', SportsActivityController());

  RxBool isPreferenceSportsOnly = RxBool(false);
  RxBool isFollowedFriendsOnly = RxBool(false);

  @override
  Widget build(BuildContext context) {
    return Obx(() => MapScaffold(
            title: 'Explore Sports Activity',
            navIndex: 1,
            role: Role.sportsLover,
            stream: sportsActivityController.getSportsActivityMarkerList(
                isPreferenceSportsOnly: isPreferenceSportsOnly.value,
                isFollowedFriendsOnly: isFollowedFriendsOnly.value),
            children: [
              Positioned(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SharedBoolButton(
                      tapped: isPreferenceSportsOnly.value,
                      onPressed: () {
                        isPreferenceSportsOnly.value =
                            !(isPreferenceSportsOnly.value);
                      },
                      text: 'Preference Sports',
                    ),
                    SharedBoolButton(
                      tapped: isFollowedFriendsOnly.value,
                      onPressed: () {
                        isFollowedFriendsOnly.value =
                            !(isFollowedFriendsOnly.value);
                      },
                      text: 'Followed Friends',
                    ),
                    const SizedBox(width: 30,)
                  ],
                ),
              ),
              Positioned(
                  bottom: 50,
                  child: SharedButton(
                      width: MediaQuery.of(context).size.width * 0.8,
                      onPressed: () {
                        sportsActivityController.cleanForm();
                        Get.to(OrganizeSportsActivity());
                      },
                      text: 'Organize Sports Activity')),
            ]));
  }
}
