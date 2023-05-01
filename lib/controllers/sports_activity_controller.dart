import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/models/sports_activity_comment.dart';
import 'package:jomsports/models/user.dart';
import 'package:jomsports/services/map_location_picker_service.dart';
import 'package:jomsports/shared/constant/join_status.dart';
import 'package:jomsports/shared/constant/map.dart';
import 'package:jomsports/shared/constant/sports.dart';
import 'package:jomsports/shared/constant/sports_activity_status.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:map_location_picker/map_location_picker.dart';

class SportsActivityController extends GetxController {
  final UserController userController = Get.find(tag: 'userController');

  @override
  Future<void> onInit() async {
    super.onInit();
    await initMap();
  }

  //organize
  GlobalKey<FormState> organizeFormKey = GlobalKey<FormState>();
  SportsType? sportsTypeValue;
  String? dateTimeValue;
  TextEditingController maxParticipantsTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  RxDouble lat = RxDouble(0);
  RxDouble lon = RxDouble(0);

  Future<void> cleanForm() async {
    organizeFormKey = GlobalKey<FormState>();
    sportsTypeValue = null;
    dateTimeValue = null;
    maxParticipantsTextController = TextEditingController();
    descriptionTextController = TextEditingController();
    addressTextController = TextEditingController();
    await initMap();
  }

  Future initMap() async {
    MapLocationPickerService geolocatorService = MapLocationPickerService();
    Position? position = await geolocatorService.determinePosition();
    if (position != null) {
      lat.value = position.latitude;
      lon.value = position.longitude;
    } else {
      lat.value = MapConstant.defaultLat;
      lon.value = MapConstant.defaultLon;
    }
  }

  void onPickLocation(String address, double lat, double lon) {
    addressTextController.text = address;
    this.lat.value = lat;
    this.lon.value = lon;
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
        lat: lat.value,
        lon: lon.value,
        description: descriptionTextController.text,
        status: SportsActivityStatus.open);
    return await sportsActivity
        .organizeSportsActivity(userController.currentUser.userID);
  }

  //sports activity map
  Stream<List<Marker>> getSportsActivityMarkerList(
      {bool isPreferenceSportsOnly = false,
      bool isFollowedFriendsOnly = false}) {
    Stream<List<Marker>> list;
    if (isPreferenceSportsOnly && isFollowedFriendsOnly) {
      var preferenceSports = userController.currentUser.preferenceSports;
      var followedFriends = userController.currentUser.followedFriends;
      list = SportsActivity.getSportsActivityMarkerList(
          preferenceSports: preferenceSports,
          followedFriends: followedFriends,
          lat: lat.value,
          lon: lon.value);
    } else if (isPreferenceSportsOnly) {
      var preferenceSports = userController.currentUser.preferenceSports;
      list = SportsActivity.getSportsActivityMarkerList(
          preferenceSports: preferenceSports, lat: lat.value, lon: lon.value);
    } else if (isFollowedFriendsOnly) {
      var followedFriends = userController.currentUser.followedFriends;
      list = SportsActivity.getSportsActivityMarkerList(
          followedFriends: followedFriends, lat: lat.value, lon: lon.value);
    } else {
      list = SportsActivity.getSportsActivityMarkerList(
          lat: lat.value, lon: lon.value);
    }
    return list;
  }

  //view sports activity
  SportsActivity? selectedSportsActivity;
  List<String> participantsID = [];
  Future initSportsActivity(String saID) async {
    selectedSportsActivity = await SportsActivity.getSportsActivity(saID);

    if (selectedSportsActivity == null) {
      SharedDialog.errorDialog();
      Get.back();
    }

    initCommentForm();
  }

  Stream<List<User>> getParticipants() {
    return selectedSportsActivity!.getParticipants();
  }

  Stream<JoinStatus> isJoined() {
    return selectedSportsActivity!.isJoined(userController.currentUser.userID);
  }

  //join sports activity
  Future joinSportsActivity() async {
    await selectedSportsActivity!
        .joinSportsActivity(userController.currentUser.userID);
  }

  Future leaveSportsActivity() async {
    await selectedSportsActivity!
        .leaveSportsActivity(userController.currentUser.userID);
  }

  //comment
  Stream<List<SportsActivityComment>> getCommentList() {
    return SportsActivityComment.getCommentList(selectedSportsActivity!.saID);
  }

  GlobalKey<FormState> commentFormKey = GlobalKey<FormState>();
  TextEditingController commentTextController = TextEditingController();

  Future onComment() async {
    SportsActivityComment comment = SportsActivityComment(
        saCommentID: '',
        content: commentTextController.text,
        dateTime: DateTime.now().toString(),
        saID: selectedSportsActivity!.saID,
        user: userController.currentUser);

    await comment.comment();
  }

  void cleanComment() {
    commentTextController.text = '';
  }

  void initCommentForm() {
    commentTextController = TextEditingController();
    commentTextController = TextEditingController();
  }
}
