import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/views/sports_activity/sports_activity/sports_activity_page.dart';
import 'package:jomsports/views/sports_activity/view_sports_activity/view_sports_activity_page.dart';

class SportsLoverHome extends StatelessWidget {
  SportsLoverHome({super.key});

  final SportsActivityController sportsActivityController =
      Get.put(tag: 'sportsActivityController', SportsActivityController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Upcoming',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        StreamBuilder<List<SportsActivity>>(
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
                        children: [
                          const Text('- No upcoming sports activity -'),
                          SharedButton(
                              onPressed: () => Get.to(SportsActivityPage()),
                              text: 'Explore')
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Card(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
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
                          onTap: () async {
                            await sportsActivityController.initSportsActivity(
                                sportsActivityList[index].saID);
                            Get.to(() =>ViewSportsActivityPage());
                          },
                        ),
                        const Divider()
                      ],
                    ),
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
      ],
    );
  }
}
