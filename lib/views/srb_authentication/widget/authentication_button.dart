import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_related_business_controller.dart';
import 'package:jomsports/shared/widget/button/button.dart';

class AuthenticationButton extends StatelessWidget {
  AuthenticationButton({super.key, required this.userID});

  final SportsRelatedBusinessController sportsRelatedBusinessController =
      Get.find(tag: 'sportsRelatedBusinessController');

  final String userID;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SharedButton(
              text: 'Authenticate',
              fontSize: 16,
              width: 150,
              onPressed: () async {
                await sportsRelatedBusinessController.authenticate(userID);
              },
            ),
            SharedButton(
              text: 'Reject',
              fontSize: 16,
              width: 150,
              danger: true,
              onPressed: () async {
                await sportsRelatedBusinessController.reject(userID);
              },
            ),
          ],
        ),
      ],
    );
  }
}
