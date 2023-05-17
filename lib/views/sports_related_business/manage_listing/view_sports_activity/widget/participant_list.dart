import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/models/sports_lover.dart';
import 'package:jomsports/models/user.dart';
import 'package:jomsports/shared/widget/button/bool_button.dart';

class ParticipantListWidget extends StatelessWidget {
  ParticipantListWidget({super.key});

  final SportsActivityController sportsActivityController =
      Get.find(tag: 'sportsActivityController');

  @override
  Widget build(BuildContext context) {
    SportsActivity sportsActivity =
        sportsActivityController.selectedSportsActivity!;
    return StreamBuilder<List<User>>(
      stream: sportsActivityController.getParticipants(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (snapshot.hasData) {
          final participants = snapshot.data!;
          sportsActivityController.participantsID =
              participants.map((e) => e.userID).toList();
          return Row(
            children: [
              Text(
                'Players (${participants.length}/${sportsActivity.maxParticipants}): ',
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: LimitedBox(
                  maxHeight: 250,
                  child: ListView.builder(
                    itemCount: participants.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (context, index) {
                      User participant = participants[index];
                      return ListTile(
                        leading: CircleAvatar(
                            radius: 20,
                            child: participant.profilePictureUrl != null &&
                                    participant.profilePictureUrl!.isNotEmpty
                                ? ClipOval(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Ink.image(
                                          image: NetworkImage(
                                              participant.profilePictureUrl!),
                                          fit: BoxFit.cover,
                                          width: 150,
                                          height: 150,
                                          child: const InkWell(
                                              /* onTap: onClicked */)),
                                    ),
                                  )
                                : const Icon(Icons.person)),
                        title: Text(
                          participant.name,
                          softWrap: true,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              participant.phoneNo,
                              softWrap: true,
                            ),
                            
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
