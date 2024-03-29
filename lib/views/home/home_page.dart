import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_simple.dart';
import 'package:jomsports/views/authentication/edit_profile/edit_profile_sports_lover_page.dart';
import 'package:jomsports/views/authentication/edit_profile/edit_profile_sports_related_business_page.dart';
import 'package:jomsports/views/home/widget/admin_home.dart';
import 'package:jomsports/views/home/widget/sports_lover_home.dart';
import 'package:jomsports/views/home/widget/sports_related_business_home.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final UserController userController = Get.find(tag: 'userController');

  @override
  Widget build(BuildContext context) {
    return SimpleScaffold(
        role: userController.currentUser.userType,
        navIndex: 0,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    if (userController.currentUser.userType != Role.admin) {
                      await userController.initProfileData();
                      switch (userController.currentUser.userType) {
                        case Role.sportsLover:
                          Get.to(() => EditProfileSportsLoverPage());
                          break;
                        case Role.sportsRelatedBusiness:
                          Get.to(() => EditProfileSportsRelatedBusinessPage());
                          break;
                        default:
                          break;
                      }
                    }
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CircleAvatar(
                              radius: 50,
                              child: userController.profilePictureUrl.isNotEmpty
                                  ? ClipOval(
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Ink.image(
                                            image: NetworkImage(userController
                                                .profilePictureUrl),
                                            fit: BoxFit.cover,
                                            width: 150,
                                            height: 150,
                                            child: const InkWell(
                                                /* onTap: onClicked */)),
                                      ),
                                    )
                                  : const Icon(Icons.person)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Hi, ${userController.currentUser.name}',
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                    softWrap: true,
                                  ),
                                ),
                                // if (userController.currentUser.userType !=
                                //     Role.admin)
                                //   SharedButton(
                                //       onPressed: () async {
                                //         await userController.initProfileData();
                                //         switch (userController
                                //             .currentUser.userType) {
                                //           case Role.sportsLover:
                                //             Get.to(() =>
                                //                 EditProfileSportsLoverPage());
                                //             break;
                                //           case Role.sportsRelatedBusiness:
                                //             Get.to(() =>
                                //                 EditProfileSportsRelatedBusinessPage());
                                //             break;
                                //           default:
                                //             break;
                                //         }
                                //       },
                                //       text: 'Edit Profile'),
                                IconButton(
                                  icon: const Icon(Icons.logout),
                                  color: const Color(ColorConstant.buttonBackgroundColor),
                                  onPressed: () async {
                                    await userController.logout().then((value) {
                                      if (value != null) {
                                        SharedDialog.alertDialog(
                                            'Error', value);
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if (userController.currentUser.userType == Role.sportsLover)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SportsLoverHome(),
                  ),
                if (userController.currentUser.userType ==
                    Role.sportsRelatedBusiness)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SportsRelatedBusinessHome(),
                  ),
                if (userController.currentUser.userType == Role.admin)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: AdminHome(),
                  ),
              ],
            ),
          ),
        ));
  }
}
