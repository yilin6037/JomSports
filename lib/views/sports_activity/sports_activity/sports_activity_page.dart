import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/button.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_map.dart';
import 'package:jomsports/views/sports_activity/organize_sports_activity/organize_sports_activity_page.dart';

class SportsActivityPage extends StatelessWidget {
  SportsActivityPage({super.key});

  final SportsActivityController sportsActivityController =
      Get.put(tag: 'sportsActivityController', SportsActivityController());

  @override
  Widget build(BuildContext context) {
    return MapScaffold(
        title: 'Explore Sports Activity',
        navIndex: 1,
        role: Role.sportsLover,
        children: [
          Positioned(
              bottom: 50,
              child: SharedButton(
                width: MediaQuery.of(context).size.width * 0.8,
                  onPressed: () async {
                    sportsActivityController.cleanForm();
                    await sportsActivityController.initMap();
                    Get.to(OrganizeSportsActivity());
                  },
                  text: 'Organize Sports Activity')),
        ]);
  }
}
