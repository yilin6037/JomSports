import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/views/authentication/login/login_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const GetMaterialApp(
    defaultTransition: Transition.noTransition,transitionDuration: Duration.zero,
    home: LoginPage(),
    debugShowCheckedModeBanner: false
  ));
}