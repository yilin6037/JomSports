import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/views/authentication/login/login_page.dart';

import 'shared/constant/font.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    defaultTransition: Transition.noTransition,
    transitionDuration: Duration.zero,
    home: const LoginPage(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: const Color(ColorConstant.buttonBackgroundColor),
      fontFamily: FontConstant.acme,
    ),
  ));
}
