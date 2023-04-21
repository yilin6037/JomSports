import 'package:jomsports/models/admin.dart';
import 'package:jomsports/models/sports_lover.dart';
import 'package:jomsports/models/sports_related_business.dart';
import 'package:jomsports/services/authentication_service_firebase.dart';
import 'package:jomsports/services/user_service_firebase.dart';
import 'package:jomsports/shared/constant/role.dart';

class User {
  String userID;
  String name;
  String email;
  String phoneNo;
  Role userType;

  User(
      {this.userID = '',
      this.name = '',
      this.email = '',
      this.phoneNo = '',
      this.userType = Role.notLoginned});

  void setUserData(User user) {
    userID = user.userID;
    name = user.name;
    email = user.email;
    phoneNo = user.phoneNo;
    userType = user.userType;
  }

  static Future login(String email, String password) async {
    AuthenticationServiceFirebase authenticationServiceFirebase =
        AuthenticationServiceFirebase();
    return await authenticationServiceFirebase.signIn(
        email: email, password: password);
  }

  static Future logout() async {
    AuthenticationServiceFirebase authenticationServiceFirebase =
        AuthenticationServiceFirebase();
    return await authenticationServiceFirebase.signOut();
  }

  static Future getUser(String userID) async {
    UserServiceFirebase userServiceFirebase = UserServiceFirebase();
    User user = await userServiceFirebase.getUser(userID);

    switch (user.userType) {
      case Role.sportsLover:
        SportsLover sportsLover = SportsLover();
        sportsLover.setUserData(user);
        await sportsLover.setSportsLoverData();
        return sportsLover;
      case Role.sportsRelatedBusiness:
        SportsRelatedBusiness sportsRelatedBusiness = SportsRelatedBusiness();
        sportsRelatedBusiness.setUserData(user);
        await sportsRelatedBusiness.setSportsRelatedBusinessData();
        return sportsRelatedBusiness;
      case Role.admin:
        Admin admin = Admin();
        admin.setUserData(user);
        return admin;
      default:
        return user;
    }
  }

  static Future<bool> resetPassword(String email) async {
    AuthenticationServiceFirebase authenticationServiceFirebase =
        AuthenticationServiceFirebase();
    return await authenticationServiceFirebase.resetPassword(email);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phoneNo': phoneNo,
        'userType': userType.name,
      };

  User.fromJson(Map<String, dynamic>? json)
      : this(
            name: json?['name'],
            email: json?['email'],
            phoneNo: json?['phoneNo'],
            userType: Role.values.byName(json?['userType']));
}
