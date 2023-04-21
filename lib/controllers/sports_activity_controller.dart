import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/services/map_location_picker_service.dart';
import 'package:jomsports/shared/constant/map.dart';
import 'package:jomsports/shared/constant/sports.dart';
import 'package:map_location_picker/map_location_picker.dart';

class SportsActivityController extends GetxController {
  final UserController userController = Get.find(tag: 'userController');

  GlobalKey<FormState> organizeFormKey = GlobalKey<FormState>();
  SportsType? sportsTypeValue;
  String? dateTimeValue;
  TextEditingController maxParticipantsTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  double lat = 0;
  double lon = 0;

  void cleanForm() {
    organizeFormKey = GlobalKey<FormState>();
    sportsTypeValue = null;
    dateTimeValue = null;
    maxParticipantsTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    addressTextController = TextEditingController();
    lat = 0;
    lon = 0;
  }

  Future initMap() async {
    MapLocationPickerService geolocatorService = MapLocationPickerService();
    Position? position = await geolocatorService.determinePosition();
    if (position != null) {
      lat = position.latitude;
      lon = position.longitude;
    } else {
      lat = MapConstant.defaultLat;
      lon = MapConstant.defaultLon;
    }
  }

  void onPickLocation(String address, double lat, double lon) {
    addressTextController.text = address;
    this.lat = lat;
    this.lon = lon;
  }

  Future organizeSportsActivity() async {
    if (sportsTypeValue == null || dateTimeValue == null) {
      return;
    }
    SportsActivity sportsActivity = SportsActivity(
        saID: '',
        sportsType: sportsTypeValue!,
        dateTime: dateTimeValue!,
        maxParticipants: int.parse(maxParticipantsTextController.text),
        address: addressTextController.text,
        lat: lat,
        lon: lon,
        description: descriptionTextController.text,
        participants: [userController.currentUser.userID]);
    return await sportsActivity.organizeSportsActivity();
  }
}
