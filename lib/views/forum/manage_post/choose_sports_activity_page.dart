import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/forum_controller.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';

class ChooseSportsActivityPage extends StatelessWidget {
  ChooseSportsActivityPage({super.key});

  final ForumController forumController = Get.find(tag: 'forumController');
  final SportsActivityController sportsActivityController =
      Get.put(tag: 'sportsActivityController', SportsActivityController());

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: 'Choose Joined Sports Activity',
      role: forumController.userController.currentUser.userType,
      navIndex: forumController.navIndex,
      body: StreamBuilder<List<SportsActivity>>(
        stream: sportsActivityController.getUpcomingSportsActivity(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          } else if (snapshot.hasData) {
            final sportsActivityList = snapshot.data!;
            if (sportsActivityList.isEmpty) {
              return Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      children: const [
                        Text('- No upcoming sports activity -'),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Card(
              child: ListView.builder(
                itemCount: sportsActivityList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) => Column(
                  children: [
                    ListTile(
                      leading: Image.asset(
                        sportsActivityList[index].sportsType.mapMarker,
                        height: 100,
                      ),
                      title: Text(
                          '${sportsActivityList[index].sportsType.sportsName} Activity'),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(sportsActivityList[index].dateTime)
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
                                sportsActivityList[index].address,
                                softWrap: true,
                              ))
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        forumController.onSelectSportsActivity(sportsActivityList[index]);
                        Get.back();
                      },
                    ),
                    const Divider()
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
