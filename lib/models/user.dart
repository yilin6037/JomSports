import 'package:flutter/material.dart';
import 'package:jomsports/services/authentication_service_firebase.dart';

class User {
  String userID;
  String name;
  String email;
  String phoneNo;
  String userType;

  User({
    this.userID = '',
    this.name = '',
    this.email = '',
    this.phoneNo = '',
    this.userType = ''
  });

  static Future findUser(String email, String password) async{
    AuthenticationServiceFirebase authenticationServiceFirebase = AuthenticationServiceFirebase();
    return await authenticationServiceFirebase.signIn(email: email, password: password);
  }
}
