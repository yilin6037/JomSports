import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/models/user.dart';

class UserController extends GetxController {
  //login
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  Future<bool> verifyUser() async {
    Get.put('',tag: 'message');
    var signInResult = await User.findUser(
        emailTextController.text, passwordTextController.text);
    bool isUser = signInResult!=null;
    if(isUser){
      currentUser.userID = signInResult.uid;
    }
    return isUser;
  }

  User currentUser = User();
}
