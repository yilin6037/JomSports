import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/models/appointment.dart';
import 'package:jomsports/models/sports_facility.dart';
import 'package:jomsports/models/sports_related_business.dart';
import 'package:jomsports/services/map_location_picker_service.dart';
import 'package:jomsports/shared/constant/map.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/chart/piechart.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;

class SportsRelatedBusinessController extends GetxController {
  //sports shop map
  RxDouble lat = RxDouble(0);
  RxDouble lon = RxDouble(0);
  Future<LatLng> initMap() async {
    MapLocationPickerService geolocatorService = MapLocationPickerService();
    Position? position = await geolocatorService.determinePosition();
    if (position != null) {
      lat.value = position.latitude;
      lon.value = position.longitude;
    } else {
      lat.value = MapConstant.defaultLat;
      lon.value = MapConstant.defaultLon;
    }
    return LatLng(lat.value, lon.value);
  }

  Stream<List<Marker>> getSportsActivityMarkerList(
      {required Function(SportsRelatedBusiness) onTap, bool isSFOnly = false}) {
    return SportsRelatedBusiness.getSportsRelatedBusinessMarkerList(
        lat: lat.value, lon: lon.value, onTap: onTap, isSFOnly: isSFOnly);
  }

  //view srb
  SportsRelatedBusiness? selectedSRB;
  bool initSRB(SportsRelatedBusiness sportsRelatedBusiness) {
    selectedSRB = sportsRelatedBusiness;
    if (selectedSRB == null) {
      SharedDialog.errorDialog();
      Get.back();
      return false;
    } else {
      final ListingController listingController =
          Get.put(tag: 'listingController', ListingController());
      listingController.initSportsRelatedBusiness(selectedSRB!.userID);
      return true;
    }
  }

  //authentication status
  UserController userController = Get.find(tag: 'userController');
  int navIndex = 0;
  int initIndex() {
    switch (userController.currentUser.userType) {
      case Role.admin:
        navIndex = 1;
        break;
      case Role.sportsLover:
        navIndex = 2;
        break;
      default:
        navIndex = 0;
        break;
    }
    return navIndex;
  }

  Stream<List<SportsRelatedBusiness>> getPendingSRB() {
    return SportsRelatedBusiness.getPendingSRB();
  }

  Future authenticate(String userID) async {
    return await SportsRelatedBusiness.authenticate(userID);
  }

  Future reject(String userID) async {
    return await SportsRelatedBusiness.reject(userID);
  }

  Future<Uint8List> getBytesFromAsset(
      {required String path, required int width}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Stream<List<Appointment>> getUpcomingAppointment() {
    return Appointment.getUpcomingAppointment(
        userController.currentUser.userID);
  }

  Future<String> getSportsFacilityName(String listingID) async {
    return await SportsFacility.getSportsFacilityName(listingID);
  }

  Stream<List<ChartData>> getSRBSummary() {
    return SportsRelatedBusiness.getSRBSummary();
  }
}
