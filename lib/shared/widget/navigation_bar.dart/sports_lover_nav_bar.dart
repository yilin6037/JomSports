import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/controllers/sports_related_business_controller.dart';
import 'package:jomsports/views/home/home_page.dart';
import 'package:jomsports/views/sports_activity/sports_activity/sports_activity_page.dart';
import 'package:jomsports/views/sports_related_business/view_sports_related_business/sports_related_business_page.dart';

class SportsLoverNavBar extends StatelessWidget {
  const SportsLoverNavBar({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (value) async {
        switch (value) {
          case 0:
            Get.to(() => HomePage());
            break;
          case 1:
            //sport activity
            final SportsActivityController sportsActivityController = Get.put(
                tag: 'sportsActivityController', SportsActivityController());
            await sportsActivityController.initMap();
            Get.to(() => SportsActivityPage());
            break;
          case 2:
            //sports shop
            final SportsRelatedBusinessController
                sportsRelatedBusinessController = Get.put(
                    tag: 'sportsRelatedBusinessController',
                    SportsRelatedBusinessController());
            await sportsRelatedBusinessController.initMap();
            Get.to(() => SportsRelatedBusinessPage());
            break;
          case 3:
            //forum
            break;
          default:
            Get.to(() => HomePage());
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.sports_handball_outlined),
          label: 'Activity',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store_outlined),
          label: 'Shops',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.diversity_1_outlined),
          label: 'Forum',
        ),
      ],
    );
  }
}
