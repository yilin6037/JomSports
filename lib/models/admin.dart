import 'package:jomsports/models/user.dart';
import 'package:jomsports/shared/constant/role.dart';

class Admin extends User {
  Admin(
      {String userID = '',
      String name = '',
      String email = '',
      String phoneNo = ''})
      : super(
            userID: userID,
            name: name,
            email: email,
            phoneNo: phoneNo,
            userType: Role.admin);
}