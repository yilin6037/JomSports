import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/authentication/login/login_page.dart';
import 'package:jomsports/views/authentication/widget/sports_related_business_profile_form.dart';

class RegisterSportsRelatedBusinessPage extends StatelessWidget {
  RegisterSportsRelatedBusinessPage({super.key});

  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: 'Register Sports Related Business',
      role: userController.currentUser.userType,
      body: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: SportsRelatedBusinessProfileForm(
            buttonText: 'Register',
            onSubmitted: register,
            enabledEmailPassword: true,
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    await userController.registerSportsRelatedBusiness().then((value) {
      if (value) {
        userController.cleanLoginData();
        SharedDialog.directDialog('Register Successful',
            'Your account is successfully created', const LoginPage());
        userController.cleanProfileData();
      } else {
        SharedDialog.alertDialog('Register Failed', Get.find(tag: 'message'));
      }
    });
  }
}
