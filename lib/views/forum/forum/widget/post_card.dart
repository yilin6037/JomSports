import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/forum_controller.dart';
import 'package:jomsports/models/post.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/views/forum/forum/view_post_page.dart';
import 'package:jomsports/views/forum/forum/widget/sports_activity_card.dart';
import 'package:jomsports/views/forum/manage_post/edit_post_page.dart';

class PostCard extends StatelessWidget {
  PostCard({super.key, required this.post, required this.isCurrentUser});

  final ForumController forumController = Get.find(tag: 'forumController');

  final Post post;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        forumController.initPost(post);
        Get.to(ViewPostPage());
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
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
                                        if (forumController.selectedUser.value ==
                                            null) {
                                          forumController.initWall(
                                              post.user.userID);
                                        }
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
                            if (forumController.selectedUser.value == null) {
                              forumController.initWall(post.user.userID);
                            }
                          },
                          child: Text(
                            '${post.user.name} | ${post.dateTime.substring(0, 16)}',
                            style: const TextStyle(
                                fontSize: 14,
                                color:
                                    Color(ColorConstant.notSelectedTextColor)),
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
                  )
                ],
              ),
              if (post.postImages.isNotEmpty)
                ClipRect(
                  child: Material(
                    color: Colors.transparent,
                    child: Ink.image(
                        image: NetworkImage(post.postImages.first),
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                        child: const InkWell()),
                  ),
                ),
              if (post.sportsActivity != null)
                SportsActivityCard(sportsActivity: post.sportsActivity!),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.comment,
                    color: Color(ColorConstant.buttonBackgroundColor),
                    size: 20,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    post.commentNo.toString(),
                    style: const TextStyle(
                        color: Color(ColorConstant.buttonBackgroundColor)),
                  ),
                  if (isCurrentUser)
                    Row(
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
                                  forumController.initPost(post);
                                  await forumController.deletePost();
                                  SharedDialog.alertDialog('Success',
                                      'Post is deleted successfully');
                                },
                                onCancel: () {});
                          },
                        )
                      ],
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
