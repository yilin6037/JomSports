import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/shared/constant/sports.dart';
import 'package:jomsports/shared/widget/button.dart';
import 'package:jomsports/views/authentication/widget/user_data_textfield.dart';

class SportsLoverProfileForm extends StatelessWidget {
  SportsLoverProfileForm(
      {super.key,
      required this.buttonText,
      required this.onSubmitted,
      this.enabledEmailPassword = false});

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

          //preference sports
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Preference Sports: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              ListView.builder(
                itemBuilder: (context, index) {
                  return Obx(() => CheckboxListTile(
                        value: userController
                            .preferenceSportsCheckbox[index].value,
                        onChanged: (value) {
                          if (value != null) {
                            userController
                                .preferenceSportsCheckbox[index].value = value;
                          }
                        },
                        title: Text(
                          SportsType.values[index].sportsName,
                        ),
                      ));
                },
                itemCount: SportsType.values.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
              ),
            ],
          ),

          // submit button
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
