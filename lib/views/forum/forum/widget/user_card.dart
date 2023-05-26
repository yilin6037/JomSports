import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/forum_controller.dart';
import 'package:jomsports/models/user.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/views/forum/manage_post/create_post_page.dart';

class UserCard extends StatelessWidget {
  UserCard({super.key});

  final ForumController forumController = Get.find(tag: 'forumController');

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Rx<dynamic> selectedUser = Rx(null);
      if (forumController.selectedUser.value == null) {
        selectedUser.value = forumController.userController.currentUser;
      } else {
        selectedUser.value = forumController.selectedUser.value;
      }
      return GestureDetector(
        onTap: () {
          if (forumController.selectedUser.value == null) {
            forumController
                .initWall(forumController.userController.currentUser.userID);
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
                    child: selectedUser.value!.profilePictureUrl != null &&
                            selectedUser.value!.profilePictureUrl!.isNotEmpty
                        ? ClipOval(
                            child: Material(
                              color: Colors.transparent,
                              child: Ink.image(
                                  image: NetworkImage(
                                      selectedUser.value!.profilePictureUrl!),
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                  child: const InkWell(/* onTap: onClicked */)),
                            ),
                          )
                        : const Icon(Icons.person)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedUser.value!.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                      if(selectedUser.value!.userType ==Role.sportsRelatedBusiness)
                      Text(selectedUser.value!.authenticationStatus.authenticationText),
                      const SizedBox(
                        height: 10,
                      ),
                      if (selectedUser.value!.userID ==
                          forumController.userController.currentUser.userID)
                        SharedButton(
                          text: 'Post Something',
                          onPressed: () {
                            forumController.cleanPostForm();
                            Get.to(() => CreatePostPage());
                          },
                        )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
