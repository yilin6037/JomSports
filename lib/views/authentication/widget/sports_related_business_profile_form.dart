import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/shared/widget/button.dart';
import 'package:jomsports/views/authentication/widget/user_data_textfield.dart';

class SportsRelatedBusinessProfileForm extends StatelessWidget {
  SportsRelatedBusinessProfileForm(
      {super.key, required this.buttonText, required this.onSubmitted, this.enabledEmailPassword = false});

  final UserController userController = Get.find();
  final String buttonText;
  final Function() onSubmitted;
  final bool enabledEmailPassword;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: userController.profileFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //basic info
          UserDataTextfield(enableEmailPassword: enabledEmailPassword,),

          const SizedBox(
            height: 20,
          ),

          //Location
          Text(userController.lat.toString()),
          Text(userController.lon.toString()),
          Text(userController.addressTextController.text),

          // register button
          SharedButton(
              onPressed: () {
                if (userController.profileFormKey.currentState!.validate()) {
                  onSubmitted();
                }
              },
              text: buttonText)
        ],
      ),
    );
  }
}
