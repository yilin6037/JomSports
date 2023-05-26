import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/forum_controller.dart';
import 'package:jomsports/models/post.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/forum/forum/widget/post_card.dart';
import 'package:jomsports/views/forum/forum/widget/user_card.dart';

class ForumPage extends StatelessWidget {
  ForumPage({super.key});

  final ForumController forumController =
      Get.put(tag: 'forumController', ForumController());

  @override
  Widget build(BuildContext context) {
    forumController.initIndex();
    return Obx(() {
      return DefaultScaffold(
        title: 'Forum',
        role: forumController.userController.currentUser.userType,
        navIndex: forumController.navIndex,
        back: false,
        scrollable: false,
        body: Stack(children: [
          SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    UserCard(),
                    StreamBuilder<List<Post>>(
                      stream: forumController
                          .getPostList(forumController.selectedUserID.value),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong'));
                        }
                        if (snapshot.hasData) {
                          final postList = snapshot.data!;
                          if (postList.isEmpty) {
                            return const Center(
                                child: Text(
                              'There is no post... Post Something!',
                              style: TextStyle(
                                  color: Color(
                                      ColorConstant.notSelectedTextColor)),
                            ));
                          }
                          return ListView.builder(
                            reverse: true,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemCount: postList.length,
                            itemBuilder: (context, index) => PostCard(
                              post: postList[index],
                              isCurrentUser: postList[index].user.userID ==
                                  forumController
                                      .userController.currentUser.userID,
                            ),
                          );
                        } else {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    )
                  ],
                )),
          ),
          if (forumController.selectedUser.value != null)
            Positioned(
              top: 0,
              left: 0,
              child: BackButton(
                onPressed: () {
                  forumController.initWall('');
                },
              ),
            ),
        ]),
      );
    });
  }
}
