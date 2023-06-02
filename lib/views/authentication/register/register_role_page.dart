import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/shared/constant/asset.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/authentication/register/register_sports_lover.dart';
import 'package:jomsports/views/authentication/register/register_sports_related_business.dart';

class RegisterRolePage extends StatelessWidget {
  RegisterRolePage({super.key});

  final UserController userController = Get.find(tag: 'userController');
  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        navIndex: 0,
        title: 'Choose Role',
        role: userController.currentUser.userType,
        body: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => displayPage(Role.sportsLover),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor:
                        const Color(ColorConstant.buttonBackgroundColor),
                  ),
                  child: const Icon(
                    Icons.sports_handball,
                    size: 100,
                  ),
                ),
                const Text('Player'),
                const SizedBox(
                  height: 50,
                  width: double.infinity,
                ),
                ElevatedButton(
                  onPressed: () => displayPage(Role.sportsRelatedBusiness),
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor:
                          const Color(ColorConstant.buttonBackgroundColor)),
                  child: const Icon(
                    Icons.store_outlined,
                    size: 100,
                  ),
                ),
                const Text('Provider'),
              ],
            ),
          ),
        ));
  }

  Future displayPage(Role role) async {
    userController.cleanProfileData();
    switch (role) {
      case Role.sportsLover:
        Get.to(() => RegisterSportsLoverPage());
        break;
      case Role.sportsRelatedBusiness:
        await userController.initMap();
        Get.to(() => RegisterSportsRelatedBusinessPage());
        break;
      case Role.admin:
        SharedDialog.errorDialog();
        break;
      case Role.notLoginned:
        SharedDialog.errorDialog();
        break;
    }
  }
}
