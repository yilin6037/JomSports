import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:jomsports/models/user.dart';
import 'package:jomsports/services/authentication_service_firebase.dart';
import 'package:jomsports/services/sports_related_business_service_firebase.dart';
import 'package:jomsports/services/storage_service_firebase.dart';
import 'package:jomsports/services/user_service_firebase.dart';
import 'package:jomsports/shared/constant/authentication_status.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/constant/storage_destination.dart';
import 'package:map_location_picker/map_location_picker.dart';

class SportsRelatedBusiness extends User {
  String address = '';
  double lat = 0;
  double lon = 0;
  AuthenticationStatus authenticationStatus = AuthenticationStatus.pending;
  bool hasSF = false;

  SportsRelatedBusiness(
      {String userID = '',
      String name = '',
      String email = '',
      String phoneNo = '',
      this.address = '',
      this.lat = 0,
      this.lon = 0,
      this.authenticationStatus = AuthenticationStatus.pending,
      this.hasSF = false})
      : super(
            userID: userID,
            name: name,
            email: email,
            phoneNo: phoneNo,
            userType: Role.sportsRelatedBusiness);

  Map<String, dynamic> toJsonSportsRelatedBusiness() => {
        'address': address,
        'lat': lat,
        'lon': lon,
        'authenticationStatus': authenticationStatus.name,
        'hasSF': hasSF
      };

  SportsRelatedBusiness.fromJsonSportsRelatedBusiness(
      Map<String, dynamic>? json)
      : this(
            address: json?['address'],
            lat: json?['lat'],
            lon: json?['lon'],
            authenticationStatus: AuthenticationStatus.values
                .byName(json?['authenticationStatus']),
            hasSF: json?['hasSF']);

  Future<bool> register(String password) async {
    AuthenticationServiceFirebase authenticationServiceFirebase =
        AuthenticationServiceFirebase();
    String userID = await authenticationServiceFirebase.register(
        email: email, password: password);

    if (userID == '') {
      return false;
    }

    this.userID = userID;

    UserServiceFirebase userServiceFirebase = UserServiceFirebase();
    await userServiceFirebase.createSportsRelatedBusiness(this);

    return true;
  }

  Future setSportsRelatedBusinessData() async {
    UserServiceFirebase userServiceFirebase = UserServiceFirebase();
    SportsRelatedBusiness sportsRelatedBusiness =
        await userServiceFirebase.getSportsRelatedBusiness(userID);
    lat = sportsRelatedBusiness.lat;
    lon = sportsRelatedBusiness.lon;
    address = sportsRelatedBusiness.address;
    authenticationStatus = sportsRelatedBusiness.authenticationStatus;
  }

  Future editProfile(XFile profilePictureXFile) async {
    UserServiceFirebase userServiceFirebase = UserServiceFirebase();
    await userServiceFirebase.updateSportsRelatedBusiness(this);

//profile picture
    if (profilePictureXFile.path.isNotEmpty) {
      File profilePic = File(profilePictureXFile.path);
      StorageServiceFirebase storageServiceFirebase = StorageServiceFirebase();
      await storageServiceFirebase.uploadFile(
          StorageDestination.profilePic, userID, profilePic);
    }
  }

  @override
  Future<String> getProfilePicUrl() async {
    StorageServiceFirebase storageServiceFirebase = StorageServiceFirebase();
    profilePictureUrl = await storageServiceFirebase.getImage(
        StorageDestination.profilePic, userID);
    return profilePictureUrl ?? '';
  }

  static Stream<List<Marker>> getSportsRelatedBusinessMarkerList(
      {required double lat,
      required double lon,
      required Function(SportsRelatedBusiness) onTap,
      bool isSFOnly = false}) {
    SportsRelatedBusinessServiceFirebase sportsRelatedBusinessServiceFirebase =
        SportsRelatedBusinessServiceFirebase();
    return sportsRelatedBusinessServiceFirebase
        .getSportsRelatedBusinessMarkerList(
            lat: lat, lon: lon, onTap: onTap, isSFOnly: isSFOnly);
  }

  Future setHasSF(bool value) async {
    if (value != hasSF) {
      hasSF = value;
      UserServiceFirebase userServiceFirebase = UserServiceFirebase();
      await userServiceFirebase.updateSportsRelatedBusiness(this);
    }
  }

  static Stream<List<SportsRelatedBusiness>> getPendingSRB() {
    SportsRelatedBusinessServiceFirebase sportsRelatedBusinessServiceFirebase =
        SportsRelatedBusinessServiceFirebase();
    return sportsRelatedBusinessServiceFirebase.getPendingSRB();
  }

  static Future authenticate(String userID) async {
    SportsRelatedBusinessServiceFirebase sportsRelatedBusinessServiceFirebase =
        SportsRelatedBusinessServiceFirebase();
    return sportsRelatedBusinessServiceFirebase.changeAuthenticationStatus(
        userID, AuthenticationStatus.authenticated);
  }

  static Future reject(String userID) async {
    SportsRelatedBusinessServiceFirebase sportsRelatedBusinessServiceFirebase =
        SportsRelatedBusinessServiceFirebase();
    return sportsRelatedBusinessServiceFirebase.changeAuthenticationStatus(
        userID, AuthenticationStatus.rejected);
  }
}
