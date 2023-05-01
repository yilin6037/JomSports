import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/constant/textformfield_validator.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/shared/widget/form/map_location_picker.dart';
import 'package:jomsports/shared/widget/form/textformfield.dart';
import 'package:jomsports/views/authentication/widget/user_data_textfield.dart';

class SportsRelatedBusinessProfileForm extends StatelessWidget {
  SportsRelatedBusinessProfileForm(
      {super.key,
      required this.buttonText,
      required this.onSubmitted,
      this.enabledEmailPassword = false});

  final UserController userController = Get.find(tag: 'userController');
  final String buttonText;
  final Function() onSubmitted;
  final bool enabledEmailPassword;
  RxString mapValidationMessage = RxString('');

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
          UserDataTextfield(
            enableEmailPassword: enabledEmailPassword,
          ),

          const SizedBox(
            height: 20,
          ),

          //Location
          SharedTextFormField(
            controller: userController.addressTextController,
            enabled: false,
            labelText: 'Please locate your address on the map',
            validator: ValidatorType.required,
          ),
          SharedMapLocationPicker(
            currentLat: userController.lat,
            currentLon: userController.lon,
            onPickLocation: (address, lat, lon) {
              mapValidationMessage.value = '';
              userController.onPickLocation(address, lat, lon);
            },
          ),
          Obx(() => Text(
                mapValidationMessage.value,
                style: const TextStyle(color: Color(ColorConstant.danger)),
              )),

          // register button
          SharedButton(
              onPressed: () {
                if (userController.profileFormKey.currentState!.validate()) {
                  onSubmitted();
                }
                if (userController.addressTextController.text.isEmpty) {
                  mapValidationMessage.value =
                      'Please locate the location and tap on the add location icon';
                } else {
                  mapValidationMessage.value = '';
                }
              },
              text: buttonText)
        ],
      ),
    );
  }
}
