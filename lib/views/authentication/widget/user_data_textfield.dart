import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/shared/constant/textformfield_validator.dart';
import 'package:jomsports/shared/widget/form/textformfield.dart';

class UserDataTextfield extends StatelessWidget {
  UserDataTextfield({super.key, this.enableEmailPassword = false});

  final UserController userController = Get.find(tag:'userController');
  final bool enableEmailPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // name
        SharedTextFormField(
          controller: userController.nameTextController,
          labelText: 'Name',
          hintText: 'Please enter your name',
          validator: ValidatorType.required,
        ),
        //email
        SharedTextFormField(
          controller: userController.profileEmailTextController,
          labelText: 'Email',
          hintText: 'Please enter your email',
          keyboard: TextInputType.emailAddress,
          validator: ValidatorType.email,
          enabled: enableEmailPassword,
        ),
        //password
        SharedTextFormField(
          controller: userController.profilePasswordTextController,
          labelText: 'Password',
          hintText: 'Please enter your password',
          obscureText: true,
          validator: ValidatorType.required,
          enabled: enableEmailPassword,
        ),
        //reset password button
        if (!enableEmailPassword)
          TextButton(
              onPressed: () => userController.resetPassword(userController.currentUser.email),
              child: Row(
                children: const [
                  Icon(Icons.edit),
                  Text('Tap here to edit Password'),
                ],
              )),
        //phone no
        SharedTextFormField(
          controller: userController.phoneNoTextController,
          labelText: 'Phone No.',
          hintText: 'Please enter your phone no.',
          keyboard: TextInputType.phone,
          validator: ValidatorType.phoneNo,
        )
      ],
    );
  }
}
