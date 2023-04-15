import 'package:jomsports/models/user.dart';
import 'package:jomsports/services/authentication_service_firebase.dart';
import 'package:jomsports/services/user_service_firebase.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/constant/sports.dart';

class SportsLover extends User {
  List<String> followedFriends;
  List<SportsType> preferenceSports;

  SportsLover(
      {String userID = '',
      String name = '',
      String email = '',
      String phoneNo = '',
      this.preferenceSports = const [],
      this.followedFriends = const []})
      : super(
            userID: userID,
            name: name,
            email: email,
            phoneNo: phoneNo,
            userType: Role.sportsLover);

  Map<String, dynamic> toJsonSportsLover() => {
        'preferenceSports': preferenceSports.map((e) => e.name),
        'followedFriends': followedFriends
      };

  static SportsLover fromJsonSportsLover(Map<String, dynamic>? json) {
    SportsLover sportsLover = SportsLover();
    sportsLover.preferenceSports = json?['preferenceSports']
        .map<SportsType>((j) => SportsType.values.byName(j))
        .toList();
    sportsLover.followedFriends = json?['followedFriends']
        .map<String>((j) => j as String)
        .toList();
    return sportsLover;
  }

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
    await userServiceFirebase.createSportsLover(this);

    return true;
  }

  Future setSportsLoverData() async {
    UserServiceFirebase userServiceFirebase = UserServiceFirebase();
    SportsLover sportsLover = await userServiceFirebase.getSportsLover(userID);
    preferenceSports = sportsLover.preferenceSports;
    followedFriends = sportsLover.followedFriends;
  }

  Future editProfile() async {
    UserServiceFirebase userServiceFirebase = UserServiceFirebase();
    await userServiceFirebase.updateSportsLover(this);

  }
}
