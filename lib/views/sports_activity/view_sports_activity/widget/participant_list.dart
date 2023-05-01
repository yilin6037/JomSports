import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/controllers/user_controller.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/models/sports_lover.dart';
import 'package:jomsports/models/user.dart';
import 'package:jomsports/shared/widget/button/bool_button.dart';

class ParticipantListWidget extends StatelessWidget {
  ParticipantListWidget({super.key});

  final SportsActivityController sportsActivityController =
      Get.put(tag: 'sportsActivityController', SportsActivityController());

  @override
  Widget build(BuildContext context) {
    SportsActivity sportsActivity =
        sportsActivityController.selectedSportsActivity!;
    SportsLover currentUser = sportsActivityController.userController.currentUser;
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
          if (participants.length >= sportsActivity.maxParticipants) {}
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
                      RxBool isFollowed = RxBool(false);
                      if(currentUser.followedFriends.contains(participant.userID)){
                        isFollowed.value = true;
                      }else{
                        isFollowed.value = false;
                      }
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
                            if(currentUser.userID != participant.userID)
                              Obx(() => SharedBoolButton(
                                text: isFollowed.value? 'Followed' : 'Follow',
                                onPressed: () async {
                                  if(isFollowed.value){
                                    currentUser.followedFriends.remove(participant.userID);
                                    isFollowed.value = false;
                                  }else{
                                    currentUser.followedFriends.add(participant.userID);
                                    isFollowed.value = true;
                                  }
                                  await currentUser.editFollowedFriends();
                                },
                                tapped: !isFollowed.value,
                              )),
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
