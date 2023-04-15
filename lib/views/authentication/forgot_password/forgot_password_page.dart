import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/constant/textformfield_validator.dart';
import 'package:jomsports/shared/widget/button.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/shared/widget/textformfield.dart';
import 'package:jomsports/views/authentication/login/login_page.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});
  final UserController userController = Get.find();

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: 'Reset Password',
      role: Role.notLoginned,
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: Form(
              key: userController.forgotPasswordFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const Text(
                      'Enter your email address to receive the email to reset your password.'),
                  SharedTextFormField(
                    controller: userController.emailFPTextController,
                    labelText: 'Email',
                    hintText: 'Please enter the email',
                    keyboard: TextInputType.emailAddress,
                    validator: ValidatorType.email,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SharedButton(
                      onPressed: () async {
                        if (userController.forgotPasswordFormKey.currentState!
                            .validate()) {
                          await userController.resetPassword(
                              userController.emailFPTextController.text,redirectLogin: true);
                        }
                      },
                      text: 'Submit')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
