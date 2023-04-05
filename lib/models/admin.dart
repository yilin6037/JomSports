import 'package:jomsports/models/user.dart';

class Admin extends User {
  Admin(
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