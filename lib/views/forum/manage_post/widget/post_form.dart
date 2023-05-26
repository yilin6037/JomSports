import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/forum_controller.dart';
import 'package:jomsports/shared/constant/textformfield_validator.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/shared/widget/form/textformfield.dart';

class PostForm extends StatelessWidget {
  PostForm({
    super.key,
    required this.buttonText,
    required this.onSubmitted,
  });

  final ForumController forumController = Get.find(tag: 'forumController');
  final Function() onSubmitted;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: forumController.postFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          SharedTextFormField(
            controller: forumController.titleTextEditingController,
            labelText: 'Title',
            hintText: 'Please enter the title for the post',
            validator: ValidatorType.required,
          ),
          SharedTextFormField(
            controller: forumController.contentTextEditingController,
            keyboard: TextInputType.multiline,
            labelText: 'Content',
            hintText: 'Please enter the content of the post',
            validator: ValidatorType.required,
            maxLines: 3,
          ),
          const SizedBox(
            height: 10,
          ),
          SharedButton(
            text: buttonText,
            onPressed: () async {
              if (forumController.postFormKey.currentState!.validate()) {
                await onSubmitted();
              }
            },
          )
        ],
      ),
    );
  }
}
