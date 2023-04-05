import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/user_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final UserController userController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(userController.currentUser.userID)));
  }
}