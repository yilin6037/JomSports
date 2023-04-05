import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/constant/textformfield_validator.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/shared/dialog.dart';
import 'package:jomsports/views/home/home_page.dart';
import 'package:jomsports/shared/widget/button.dart';
import 'package:jomsports/shared/widget/textformfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());
    RxDouble height = RxDouble(225);
    var keyboardOn = MediaQuery.of(context).viewInsets.bottom.obs;
    if (keyboardOn.value > 0) {
      height = RxDouble(75);
    } else {
      height = RxDouble(225);
    }
    return Scaffold(
        backgroundColor: const Color(ColorConstant.scaffoldBackgroundColor),
        appBar: AppBar(
            backgroundColor: const Color(ColorConstant.appBarBackgroundColor),
            toolbarHeight: height.value,
            title: Image.asset('assets/logo.png')),
        body: Center(
            child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
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
                            )
                          ],
                        ),
                      )),
                  /* button */
                  SharedButton(
                      onPressed: () async {
                        /* login */
                        if (userController.loginFormKey.currentState!
                            .validate()) {
                          await userController.verifyUser()
                              ? loginSuccessful()
                              : display(
                                  'Login Unsuccessful', Get.find(tag: 'message'));
                        }
                      },
                      text: 'Login'),
                  const Text('or'),
                  SharedButton(onPressed: () => {}, text: 'Register now')
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
