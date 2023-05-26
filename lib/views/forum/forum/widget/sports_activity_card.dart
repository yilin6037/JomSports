import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/views/sports_activity/view_sports_activity/view_sports_activity_page.dart';

class SportsActivityCard extends StatelessWidget {
  SportsActivityCard({super.key, required this.sportsActivity});

  final SportsActivity sportsActivity;

  final SportsActivityController sportsActivityController =
      Get.put(tag: 'sportsActivityController', SportsActivityController());

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(
          sportsActivity.sportsType.mapMarker,
          height: 100,
        ),
        title: Text('${sportsActivity.sportsType.sportsName} Activity'),
        subtitle: Column(
          children: [
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
        onTap: () async {
          await sportsActivityController
              .initSportsActivity(sportsActivity.saID);
          Get.to(() => ViewSportsActivityPage());
        },
      ),
    );
  }
}
