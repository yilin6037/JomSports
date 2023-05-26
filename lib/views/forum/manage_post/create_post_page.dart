import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/forum_controller.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/form/multi_image_picker.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/forum/manage_post/widget/attach_sports_activity.dart';
import 'package:jomsports/views/forum/manage_post/widget/post_form.dart';

class CreatePostPage extends StatelessWidget {
  CreatePostPage({super.key});

  final ForumController forumController = Get.find(tag: 'forumController');

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: 'Create Post',
      role: forumController.userController.currentUser.userType,
      navIndex: forumController.navIndex,
      body: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              PostForm(buttonText: 'Post', onSubmitted: forumController.addPost,),
              const Divider(),
              const Text(
                'Attachment:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (forumController.userController.currentUser.userType ==
                  Role.sportsLover)
                AttachSportsActivity(),
              SharedMultiImagePicker(
                  onSelectImage: forumController.onSelectPostImages),
            ],
          ),
        ),
      ),
    );
  }
}
