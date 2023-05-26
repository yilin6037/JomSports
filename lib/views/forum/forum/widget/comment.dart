import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/forum_controller.dart';
import 'package:jomsports/models/comment.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/constant/textformfield_validator.dart';
import 'package:jomsports/shared/widget/form/textformfield.dart';

class CommentWidget extends StatelessWidget {
  CommentWidget({super.key});

  final ForumController forumController = Get.find(tag: 'forumController');

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: double.maxFinite,
          child: Text(
            'Comments:',
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        StreamBuilder<List<Comment>>(
          stream: forumController.getCommentList(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            }
            if (snapshot.hasData) {
              final comments = snapshot.data!;
              if (comments.isEmpty) {
                return const Center(
                    child: Text(
                  'There is no comment',
                  style: TextStyle(
                      color: Color(ColorConstant.notSelectedTextColor)),
                ));
              }
              return LimitedBox(
                maxHeight: 450,
                child: ListView.builder(
                  reverse: true,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: comments.length,
                  itemBuilder: (context, index) => Flex(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    direction: Axis.vertical,
                    children: [
                      GestureDetector(
                        onTap: () {
                          forumController.initWall(comments[index].user.userID);
                          Get.back();
                        },
                        child: Text(
                          '${comments[index].user.name} | ${comments[index].dateTime.substring(0, 16)}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(ColorConstant.notSelectedTextColor)),
                          softWrap: true,
                        ),
                      ),
                      Text(
                        comments[index].content,
                        style: const TextStyle(fontSize: 16),
                        softWrap: true,
                      ),
                      const Divider(),
                    ],
                  ),
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
        ),
        Form(
          key: forumController.commentFormKey,
          child: Row(
            children: [
              Expanded(
                child: SharedTextFormField(
                  controller: forumController.commentTextController,
                  labelText: 'Comment Something...',
                  hintText: 'Your comment',
                  validator: ValidatorType.required,
                ),
              ),
              IconButton(
                  onPressed: () async {
                    if (forumController.commentFormKey.currentState!
                        .validate()) {
                      await forumController.onComment().then((_) {
                        forumController.cleanComment();
                      });
                    }
                  },
                  icon: const Icon(Icons.send))
            ],
          ),
        )
      ],
    );
  }
}
