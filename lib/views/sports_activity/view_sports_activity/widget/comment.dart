import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/models/sports_activity_comment.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/constant/textformfield_validator.dart';
import 'package:jomsports/shared/widget/form/textformfield.dart';

class CommentWidget extends StatelessWidget {
  CommentWidget({super.key});

  final SportsActivityController sportsActivityController =
      Get.put(tag: 'sportsActivityController', SportsActivityController());

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
        StreamBuilder<List<SportsActivityComment>>(
          stream: sportsActivityController.getCommentList(),
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
                      Text(
                        '${comments[index].user.name} | ${comments[index].dateTime.substring(0, 16)}',
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(ColorConstant.notSelectedTextColor)),
                        softWrap: true,
                      ),
                      Text(
                        comments[index].content,
                        style: const TextStyle(fontSize: 16),
                        softWrap: true,
                      ),
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
          key: sportsActivityController.commentFormKey,
          child: Row(
            children: [
              Expanded(
                child: SharedTextFormField(
                  controller: sportsActivityController.commentTextController,
                  labelText: 'Comment Something...',
                  hintText: 'Your comment',
                  validator: ValidatorType.required,
                ),
              ),
              IconButton(
                  onPressed: () async {
                    if (sportsActivityController.commentFormKey.currentState!
                        .validate()) {
                      await sportsActivityController.onComment().then((_) {
                        sportsActivityController.cleanComment();
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
