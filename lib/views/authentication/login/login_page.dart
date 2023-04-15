import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/shared/constant/textformfield_validator.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_simple.dart';
import 'package:jomsports/views/authentication/forgot_password/forgot_password_page.dart';
import 'package:jomsports/views/home/home_page.dart';
import 'package:jomsports/shared/widget/button.dart';
import 'package:jomsports/shared/widget/textformfield.dart';
import 'package:jomsports/views/authentication/register/register_role_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());

    return SimpleScaffold(
        role: userController.currentUser.userType,
        body: Center(
            child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*content*/
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 32),
                  ),
                  /* form */
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Form(
                        key: userController.loginFormKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            /* email */
                            SharedTextFormField(
                              controller: userController.emailTextController,
                              labelText: 'Email',
                              hintText: 'Please enter the email',
                              keyboard: TextInputType.emailAddress,
                              validator: ValidatorType.email,
                            ),
                            /* password */
                            SharedTextFormField(
                              controller: userController.passwordTextController,
                              labelText: 'Password',
                              hintText: 'Please enter the password',
                              obscureText: true,
                              validator: ValidatorType.required,
                            ),
                            //forgot password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      userController.cleanForgotPasswordData();
                                      Get.to(ForgotPasswordPage());
                                      userController.cleanLoginData();
                                    },
                                    child: const Text('Forgot Password')),
                              ],
                            ),
                          ],
                        ),
                      )),
                  /* button */
                  SharedButton(
                      onPressed: () async {
                        /* login */
                        if (userController.loginFormKey.currentState!
                            .validate()) {
                          await userController.login()
                              ? loginSuccessful()
                              : display('Login Unsuccessful',
                                  Get.find(tag: 'message'));
                        }
                      },
                      text: 'Login'),
                  const Text('or'),
                  SharedButton(
                      onPressed: () {
                        Get.to(RegisterRolePage());
                      },
                      text: 'Register now')
                ],
              ),
            ),
          ),
        )));
  }

  void loginSuccessful() {
    Get.offAll(HomePage());
  }

  void display(String title, String message) {
    SharedDialog.alertDialog(title, message);
  }
}
