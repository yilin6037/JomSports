import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/models/sports_lover.dart';
import 'package:jomsports/models/sports_related_business.dart';
import 'package:jomsports/models/user.dart';
import 'package:jomsports/shared/constant/authentication_status.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/constant/sports.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/views/authentication/login/login_page.dart';

class UserController extends GetxController {
  //register & edit profile
  TextEditingController nameTextController = TextEditingController();
  TextEditingController phoneNoTextController = TextEditingController();
  TextEditingController profileEmailTextController = TextEditingController();
  TextEditingController profilePasswordTextController = TextEditingController();
  GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  //sports lover
  List<RxBool> preferenceSportsCheckbox =
      List.generate(SportsType.values.length, (index) => RxBool(false));
  //sports related business
  TextEditingController addressTextController =
      TextEditingController(text: 'test address');
  double lat = 0;
  double lon = 0;

  Future<bool> registerSportsLover() async {
    Get.put('', tag: 'message');
    List<SportsType> preferenceSports = SportsType.values
        .where((element) => preferenceSportsCheckbox[element.index].value)
        .toList();
    SportsLover regUser = SportsLover(
        name: nameTextController.text,
        email: profileEmailTextController.text,
        phoneNo: phoneNoTextController.text,
        preferenceSports: preferenceSports);

    bool isSuccessful =
        await regUser.register(profilePasswordTextController.text);

    return isSuccessful;
  }

  Future<bool> registerSportsRelatedBusiness() async {
    Get.put('', tag: 'message');
    SportsRelatedBusiness regUser = SportsRelatedBusiness(
        name: nameTextController.text,
        email: profileEmailTextController.text,
        phoneNo: phoneNoTextController.text,
        address: addressTextController.text,
        lat: lat,
        lon: lon,
        authenticationStatus: AuthenticationStatus.pending);

    bool isSuccessful =
        await regUser.register(profilePasswordTextController.text);

    return isSuccessful;
  }

  void cleanProfileData() {
    nameTextController = TextEditingController();
    phoneNoTextController = TextEditingController();
    profileEmailTextController = TextEditingController();
    profilePasswordTextController = TextEditingController();
    preferenceSportsCheckbox =
        List.generate(SportsType.values.length, (index) => RxBool(false));
    addressTextController = TextEditingController(text: 'test address');
    lat = 0;
    lon = 0;
    profileFormKey = GlobalKey<FormState>();
  }

  Future<void> initProfileData() async {
    profileFormKey = GlobalKey<FormState>();
    nameTextController = TextEditingController(text: currentUser.name);
    phoneNoTextController = TextEditingController(text: currentUser.phoneNo);
    profileEmailTextController = TextEditingController(text: currentUser.email);
    profilePasswordTextController = TextEditingController(text: '******');

    switch (currentUser.userType) {
      case Role.sportsLover:
        preferenceSportsCheckbox = List.generate(
            SportsType.values.length,
            (index) => RxBool(currentUser.preferenceSports
                .contains(SportsType.values.elementAt(index))));
        break;
      case Role.sportsRelatedBusiness:
        lat = currentUser.lat;
        lon = currentUser.lon;
        addressTextController =
            TextEditingController(text: currentUser.address);
        break;
      default:
        break;
    }
  }

  Future editProfileSportsLover() async {
    List<SportsType> preferenceSports = SportsType.values
        .where((element) => preferenceSportsCheckbox[element.index].value)
        .toList();
    SportsLover editedSportsLover = SportsLover(
        userID: currentUser.userID,
        name: nameTextController.text,
        email: profileEmailTextController.text,
        phoneNo: phoneNoTextController.text,
        preferenceSports: preferenceSports);

    await editedSportsLover.editProfile();
    currentUser = await User.getUser(currentUser.userID);
  }

  Future editProfileSportsRelatedBusiness() async {
    SportsRelatedBusiness editedSportsRelatedBusiness = SportsRelatedBusiness(
        userID: currentUser.userID,
        name: nameTextController.text,
        email: profileEmailTextController.text,
        phoneNo: phoneNoTextController.text,
        lat: lat,
        lon: lon,
        address: addressTextController.text);

    await editedSportsRelatedBusiness.editProfile();
    currentUser = await User.getUser(currentUser.userID);
  }

  //login
  dynamic currentUser = User();

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  Future<bool> login() async {
    Get.put('', tag: 'message');
    var signInResult =
        await User.login(emailTextController.text, passwordTextController.text);
    bool isUser = signInResult != null;
    if (isUser) {
      currentUser = await User.getUser(signInResult.uid);
    }
    return isUser;
  }

  void cleanLoginData() {
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    loginFormKey = GlobalKey<FormState>();
  }

  //logout
  Future logout() async {
    dynamic result = await User.logout();
    currentUser = User();
    if (result == null) {
      cleanLoginData();
      SharedDialog.directDialog(
          'You have been logged out', 'Please login again.', const LoginPage());
      // Get.offAll(const LoginPage());
    } else {
      return result;
    }
  }

  //reset password
  Future resetPassword(String email, {bool redirectLogin = false}) async {
    await User.resetPassword(email).then((value) {
      if (value) {
        if(redirectLogin){
          SharedDialog.directDialog('A password reset email is sent.', 'Please check your email.', const LoginPage());
        }else{
          SharedDialog.alertDialog(
            'A password reset email is sent.', 'Please check your email.');
        }
      } else {
        String message = Get.find(tag: 'message');
        SharedDialog.alertDialog('Operation Unsuccessful', message);
      }
    });
  }

  GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  TextEditingController emailFPTextController = TextEditingController();
  void cleanForgotPasswordData() {
    forgotPasswordFormKey = GlobalKey<FormState>();
    emailFPTextController = TextEditingController();
  }
}
