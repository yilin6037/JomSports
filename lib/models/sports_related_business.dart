import 'package:jomsports/models/user.dart';

class SportsRelatedBusiness extends User{
  double lat=0;
  double lon=0;
  String authenticationStatus='';

  SportsRelatedBusiness(
      {String userID = '',
      String name = '',
      String email = '',
      String phoneNo = '',
      String userType = '',
      this.lat = 0,
      this.lon = 0,
      this.authenticationStatus = ''})
      : super(
            userID: userID,
            name: name,
            email: email,
            phoneNo: phoneNo,
            userType: userType);
}