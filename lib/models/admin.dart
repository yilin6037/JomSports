import 'package:jomsports/models/user.dart';
import 'package:jomsports/services/storage_service_firebase.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/constant/storage_destination.dart';

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

  @override
  Future<String> getProfilePicUrl() async {
    StorageServiceFirebase storageServiceFirebase = StorageServiceFirebase();
    profilePictureUrl = await storageServiceFirebase.getImage(
        StorageDestination.profilePic, userID);
    return profilePictureUrl??'';
  }
}