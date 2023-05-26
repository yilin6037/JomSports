import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/forum_controller.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/views/forum/manage_post/choose_sports_activity_page.dart';

class AttachSportsActivity extends StatelessWidget {
  AttachSportsActivity({super.key});

  final ForumController forumController = Get.find(tag: 'forumController');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          if (forumController.attachedSportsActivity.value != null) {
            return Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Get.to(() => ChooseSportsActivityPage());
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: ListTile(
                    title: Text(
                        '${forumController.attachedSportsActivity.value!.sportsType.sportsName} Activity'),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(forumController
                                .attachedSportsActivity.value!.dateTime)
                          ],
                        ),
                        //location
                        Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Text(
                              forumController
                                  .attachedSportsActivity.value!.address,
                              softWrap: true,
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return TextButton(
              style: TextButton.styleFrom(
                  foregroundColor:
                      const Color(ColorConstant.buttonBackgroundColor)),
              onPressed: () {
                Get.to(() => ChooseSportsActivityPage());
              },
              child: Row(
                children: const [
                  Icon(Icons.sports_handball_outlined),
                  Text('Attach a joined sports activity'),
                ],
              ),
            );
          }
        }),
      ],
    );
  }
}
