import 'package:jomsports/models/user.dart';
import 'package:jomsports/services/authentication_service_firebase.dart';
import 'package:jomsports/services/user_service_firebase.dart';
import 'package:jomsports/shared/constant/authentication_status.dart';
import 'package:jomsports/shared/constant/role.dart';

class SportsRelatedBusiness extends User {
  String address = '';
  double lat = 0;
  double lon = 0;
  AuthenticationStatus authenticationStatus = AuthenticationStatus.pending;

  SportsRelatedBusiness(
      {String userID = '',
      String name = '',
      String email = '',
      String phoneNo = '',
      this.address = '',
      this.lat = 0,
      this.lon = 0,
      this.authenticationStatus = AuthenticationStatus.pending})
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
        'authenticationStatus': authenticationStatus.name
      };

     SportsRelatedBusiness.fromJsonSportsRelatedBusiness(Map<String, dynamic>? json)
      : this(
            address: json?['address'],
            lat: json?['lat'],
            lon: json?['lon'],
            authenticationStatus: AuthenticationStatus.values.byName(json?['authenticationStatus']));

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

  Future setSportsRelatedBusinessData() async{
    UserServiceFirebase userServiceFirebase = UserServiceFirebase();
    SportsRelatedBusiness sportsRelatedBusiness = await userServiceFirebase.getSportsRelatedBusiness(userID);
    lat = sportsRelatedBusiness.lat;
    lon = sportsRelatedBusiness.lon;
    address = sportsRelatedBusiness.address;
    authenticationStatus = sportsRelatedBusiness.authenticationStatus;
  }

  Future editProfile() async {
    UserServiceFirebase userServiceFirebase = UserServiceFirebase();
    await userServiceFirebase.updateSportsRelatedBusiness(this);

  }
}
