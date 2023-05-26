import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/forum_controller.dart';
import 'package:jomsports/models/post.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/forum/forum/forum_page.dart';
import 'package:jomsports/views/forum/forum/widget/comment.dart';
import 'package:jomsports/views/forum/forum/widget/images_slide.dart';
import 'package:jomsports/views/forum/forum/widget/sports_activity_card.dart';
import 'package:jomsports/views/forum/manage_post/edit_post_page.dart';

class ViewPostPage extends StatelessWidget {
  ViewPostPage({super.key});

  final ForumController forumController = Get.find(tag: 'forumController');

  @override
  Widget build(BuildContext context) {
    if (forumController.selectedPost == null) {
      SharedDialog.errorDialog();
      Get.back();
    }
    return DefaultScaffold(
      title: 'Forum',
      role: forumController.userController.currentUser.userType,
      navIndex: forumController.navIndex,
      body: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<Post>(
            future: forumController.getPost(),
            builder: (context, snapshot) {
              Post post = forumController.selectedPost!;
              if (snapshot.hasData) {
                post = snapshot.data!;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!snapshot.hasData)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          radius: 20,
                          child: post.user.profilePictureUrl != null &&
                                  post.user.profilePictureUrl!.isNotEmpty
                              ? ClipOval(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Ink.image(
                                        image: NetworkImage(
                                            post.user.profilePictureUrl!),
                                        fit: BoxFit.cover,
                                        width: 150,
                                        height: 150,
                                        child: InkWell(
                                          onTap: () {
                                            forumController
                                                .initWall(post.user.userID);
                                            Get.back();
                                          },
                                        )),
                                  ),
                                )
                              : const Icon(Icons.person)),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                forumController.initWall(post.user.userID);
                                Get.back();
                              },
                              child: Text(
                                '${post.user.name} | ${post.dateTime.substring(0, 16)}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(
                                        ColorConstant.notSelectedTextColor)),
                                softWrap: true,
                              ),
                            ),
                            Text(
                              post.title,
                              style: const TextStyle(fontSize: 20),
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      post.content,
                      style: const TextStyle(fontSize: 16),
                      softWrap: true,
                    ),
                  ),
                  if (post.postImages.isNotEmpty)
                    ImagesSlide(imageUrls: post.postImages),
                  if (post.sportsActivity != null)
                    SportsActivityCard(sportsActivity: post.sportsActivity!),
                  if (post.user.userID ==
                      forumController.userController.currentUser.userID)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        SharedButton(
                          text: 'Edit',
                          fontSize: 16,
                          width: 100,
                          onPressed: () {
                            forumController.initEditPostForm(post);
                            Get.to(() => EditPostPage());
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SharedButton(
                          text: 'Delete',
                          danger: true,
                          fontSize: 16,
                          width: 100,
                          onPressed: () async {
                            SharedDialog.confirmationDialog(
                                title: 'Delete Post',
                                message:
                                    'Are you sure to delete post with the title: ${post.title}?',
                                onOK: () async {
                                  await forumController.deletePost();
                                  SharedDialog.directDialog(
                                      'Success',
                                      'Post is deleted successfully',
                                      ForumPage());
                                },
                                onCancel: () {});
                          },
                        )
                      ],
                    ),
                  const Divider(),
                  CommentWidget()
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
