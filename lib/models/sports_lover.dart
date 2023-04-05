import 'package:jomsports/models/user.dart';

class SportsLover extends User {
  List<String> followedFriends = [];
  List<String> preferenceSports = [];

  SportsLover(
      {String userID = '',
      String name = '',
      String email = '',
      String phoneNo = '',
      String userType = ''})
      : super(
            userID: userID,
            name: name,
            email: email,
            phoneNo: phoneNo,
            userType: userType);
}
