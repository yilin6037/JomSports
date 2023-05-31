import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/models/slot_unavailable.dart';
import 'package:jomsports/shared/constant/appointment_status.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/view_sports_activity/view_sports_activity_page.dart';

class AvailabilityListWidget extends StatelessWidget {
  AvailabilityListWidget({super.key});

  final ListingController listingController =
      Get.find(tag: 'listingController');

  final SportsActivityController sportsActivityController =
      Get.put(tag: 'sportsActivityController', SportsActivityController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
        child: Card(
          child: SizedBox(
            width: double.infinity,
            child: Obx(() => StreamBuilder<List<SlotUnavailable>>(
                  stream: listingController.getSlotUnavailableList(
                      listingController.selectedDate.value.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List<SlotUnavailable> slotUnavaliableList = snapshot.data!;
                    return ListView.builder(
                      itemCount: 24,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, index) {
                        SlotUnavailable? slotUnavailable =
                            slotUnavaliableList.firstWhereOrNull(
                                (element) => element.slot == index);
                        if (index <
                                listingController
                                    .selectedSF!
                                    .operatingHourList[listingController
                                            .selectedDate.value.weekday -
                                        1]
                                    .openHour ||
                            index >=
                                listingController
                                    .selectedSF!
                                    .operatingHourList[listingController
                                            .selectedDate.value.weekday -
                                        1]
                                    .closeHour) {
                          return ListTile(
                            title: Text('$index:00 - $index:59'),
                            subtitle: slotUnavailable != null &&
                                    slotUnavailable.appointment != null &&
                                    slotUnavailable.appointment!.status !=
                                        AppointmentStatus.canceled
                                ? TextButton(
                                    child: Text(
                                        'Sports Activity ${slotUnavailable.appointment!.saID}'),
                                    onPressed: () async {
                                      await sportsActivityController
                                          .initSportsActivity(slotUnavailable
                                              .appointment!.saID);
                                      listingController.selectedAppointmentID =
                                          slotUnavailable
                                              .appointment!.appointmentID;
                                      Get.to(() => ViewSportsActivityPage());
                                    },
                                  )
                                : null,
                            enabled: false,
                          );
                        }

                        if (slotUnavailable != null) {
                          return ListTile(
                            title: Text('$index:00 - $index:59'),
                            subtitle: slotUnavailable.appointment != null &&
                                    slotUnavailable.appointment!.status !=
                                        AppointmentStatus.canceled
                                ? TextButton(
                                    child: Text(
                                        'Sports Activity ${slotUnavailable.appointment!.saID}'),
                                    onPressed: () async {
                                      await sportsActivityController
                                          .initSportsActivity(slotUnavailable
                                              .appointment!.saID);
                                      listingController.selectedAppointmentID =
                                          slotUnavailable
                                              .appointment!.appointmentID;
                                      Get.to(() => ViewSportsActivityPage());
                                    },
                                  )
                                : null,
                            trailing: slotUnavailable.appointment == null ||
                                    slotUnavailable.appointment!.status ==
                                        AppointmentStatus.canceled
                                ? Switch(
                                    value: false,
                                    onChanged: (value) async {
                                      await listingController
                                          .deleteSlotUnavailable(
                                              slotUnavailable);
                                    })
                                : null,
                          );
                        }
                        return ListTile(
                          title: Text('$index:00 - $index:59'),
                          trailing: Switch(
                              value: true,
                              onChanged: (value) async {
                                await listingController
                                    .addSlotUnavailable(index);
                              }),
                        );
                      },
                    );
                  },
                )),
          ),
        ),
      ),
    );
  }
}
