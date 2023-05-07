import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/models/sports_facility.dart';
import 'package:jomsports/views/sports_related_business/view_sports_related_business/availability_page.dart';

class SportsFacilityList extends StatelessWidget {
  SportsFacilityList({super.key});

  final ListingController listingController =
      Get.find(tag: 'listingController');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SportsFacility>>(
      stream: listingController.getSFList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final sfList = snapshot.data!;
          if (sfList.isEmpty) {
            return const Center(
                child: Text('No sports facility yet.'));
          } else {
            return ListView.builder(
                itemCount: sfList.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  SportsFacility sportsFacility = sfList[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(sportsFacility.facilityName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(sportsFacility.description),
                            IconButton(
                              icon: const Icon(Icons.calendar_month_outlined),
                              onPressed: () async {
                                await listingController
                                    .initAvailability(sportsFacility.listingID);
                                Get.to(() => AvailabilityPage());
                              },
                            ),
                          ],
                        ),
                        leading: sportsFacility.listingPictureUrl != null &&
                                sportsFacility.listingPictureUrl!.isNotEmpty
                            ? ClipRRect(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Ink.image(
                                      image: NetworkImage(
                                          sportsFacility.listingPictureUrl!),
                                      fit: BoxFit.contain,
                                      width: 100,
                                      height: 100,
                                      child: const InkWell()),
                                ),
                              )
                            : const CircleAvatar(
                                radius: 50,
                                child: Icon(Icons.sports_tennis),
                              ),
                      ),
                      const Divider()
                    ],
                  );
                });
          }
        }
      },
    );
  }
}
