import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/shared/constant/asset.dart';
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
                      padding: const EdgeInsets.all(0)),
                  child: Container(
                    width: 250,
                    height: 225,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AssetConstant.sportsLover),
                            fit: BoxFit.cover)),
                    child: const Center(
                      child: Text('Sports Lover',
                          style: TextStyle(
                              fontSize: 40, shadows: [Shadow(blurRadius: 1)]),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () => displayPage(Role.sportsRelatedBusiness),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(0)),
                  child: Container(
                    width: 250,
                    height: 225,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                AssetConstant.sportsRelatedBusiness),
                            fit: BoxFit.cover)),
                    child: const Center(
                      child: Text('Sports Related Business',
                          style: TextStyle(
                              fontSize: 40, shadows: [Shadow(blurRadius: 1)]),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future displayPage(Role role) async {
    userController.cleanProfileData();
    switch (role) {
      case Role.sportsLover:
        Get.to(RegisterSportsLoverPage());
        break;
      case Role.sportsRelatedBusiness:
        await userController.initMap();
        Get.to(RegisterSportsRelatedBusinessPage());
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
