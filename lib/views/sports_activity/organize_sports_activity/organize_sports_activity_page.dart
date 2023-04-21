import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/sports_activity/organize_sports_activity/widget/sports_activity_form.dart';
import 'package:jomsports/views/sports_activity/sports_activity/sports_activity_page.dart';

class OrganizeSportsActivity extends StatelessWidget {
  OrganizeSportsActivity({super.key});

  final SportsActivityController sportsActivityController =
      Get.find(tag: 'sportsActivityController');

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: 'Organize Sports Activity',
      role: Role.sportsLover,
      navIndex: 1,
      body: Card(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
            child: SportsActivityForm(
              onSubmitted: () async {
                await sportsActivityController.organizeSportsActivity();
                SharedDialog.directDialog(
                    'Organize Successful!',
                    'The sports activity is organized successfully.',
                    SportsActivityPage());
              },
            )),
      ),
    );
  }
}
