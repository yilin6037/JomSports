import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/authentication/login/login_page.dart';
import 'package:jomsports/views/authentication/widget/sports_related_business_profile_form.dart';
import 'package:jomsports/views/home/home_page.dart';

class EditProfileSportsRelatedBusinessPage extends StatelessWidget {
  EditProfileSportsRelatedBusinessPage({super.key});

  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: 'Edit Profile',
      role: userController.currentUser.userType,
      body: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: SportsRelatedBusinessProfileForm(
            buttonText: 'Save',
            onSubmitted: editProfile,
          ),
        ),
      ),
    );
  }

  Future<void> editProfile() async {
    await userController.editProfileSportsRelatedBusiness().then((_) {
      SharedDialog.directDialog('Save Successful',
          'Your edited account is successfully save', HomePage());
      userController.cleanProfileData();
    });
  }
}
