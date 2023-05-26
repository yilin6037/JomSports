import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_related_business_controller.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_map.dart';
import 'package:jomsports/views/sports_related_business/view_sports_related_business/view_sports_related_business_page.dart';
import 'package:map_location_picker/map_location_picker.dart';

class SportsRelatedBusinessPage extends StatelessWidget {
  SportsRelatedBusinessPage({super.key});

  final SportsRelatedBusinessController sportsRelatedBusinessController =
      Get.put(
          tag: 'sportsRelatedBusinessController',
          SportsRelatedBusinessController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LatLng>(
        future: sportsRelatedBusinessController.initMap(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MapScaffold(
              title: 'Explore Shops',
              role: Role.sportsLover,
              navIndex: 2,
              currentLatLng: snapshot.data!,
              stream: sportsRelatedBusinessController
                  .getSportsActivityMarkerList(onTap: (sportsRelatedBusiness) {
                bool isInit = sportsRelatedBusinessController
                    .initSRB(sportsRelatedBusiness);
                if (isInit) {
                  Get.to(() => ViewSportsRelatedBusinessPage());
                }
              }),
              children: const [],
            );
          } else {
            return DefaultScaffold(
              body: const CircularProgressIndicator(),
              title: 'Explore Shops',
              role: Role.sportsLover,
              navIndex: 2,
              back: false,
            );
          }
        });
  }
  
}
