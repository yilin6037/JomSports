import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_related_business_controller.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_map.dart';
import 'package:map_location_picker/map_location_picker.dart';

class SportsRelatedBusinessPage extends StatelessWidget {
  SportsRelatedBusinessPage({super.key});

  final SportsRelatedBusinessController sportsRelatedBusinessController =
      Get.put(
          tag: 'sportsRelatedBusinessController',
          SportsRelatedBusinessController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var currentLatLng = LatLng(sportsRelatedBusinessController.lat.value,
          sportsRelatedBusinessController.lon.value);
      return MapScaffold(
        title: 'Explore Shops',
        role: Role.sportsLover,
        navIndex: 2,
        currentLatLng: currentLatLng,
        stream: sportsRelatedBusinessController.getSportsActivityMarkerList(
            onTap: (sportsRelatedBusiness) =>
                sportsRelatedBusinessController.initSRB(sportsRelatedBusiness)),
        children: const [],
      );
    });
  }
}
