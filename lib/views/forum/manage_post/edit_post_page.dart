import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/forum_controller.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/forum/forum/widget/images_slide.dart';
import 'package:jomsports/views/forum/forum/widget/sports_activity_card.dart';
import 'package:jomsports/views/forum/manage_post/widget/post_form.dart';

class EditPostPage extends StatelessWidget {
  EditPostPage({super.key});

  final ForumController forumController = Get.find(tag: 'forumController');

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: 'Edit Post',
      role: forumController.userController.currentUser.userType,
      navIndex: forumController.navIndex,
      body: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              PostForm(
                buttonText: 'Edit Post',
                onSubmitted: forumController.editPost,
              ),
              const Divider(),
              if (forumController.selectedPost != null &&
                  forumController.selectedPost!.postImages.isNotEmpty)
                ImagesSlide(
                    imageUrls: forumController.selectedPost!.postImages),
              if (forumController.selectedPost != null &&
                  forumController.selectedPost!.sportsActivity != null)
                SportsActivityCard(
                    sportsActivity:
                        forumController.selectedPost!.sportsActivity!),
            ],
          ),
        ),
      ),
    );
  }
}
