import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/controllers/sports_related_business_controller.dart';
import 'package:jomsports/models/appointment.dart';
import 'package:jomsports/models/slot_unavailable.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/views/sports_activity/organize_sports_activity/organize_sports_activity_page.dart';
import 'package:jomsports/views/sports_activity/view_sports_activity/view_sports_activity_page.dart';

class AvailabilityListWidget extends StatelessWidget {
  AvailabilityListWidget({super.key});

  final ListingController listingController =
      Get.find(tag: 'listingController');

  final SportsActivityController sportsActivityController =
      Get.find(tag: 'sportsActivityController');

  final SportsRelatedBusinessController sportsRelatedBusinessController =
      Get.put(
          tag: 'sportsRelatedBusinessController',
          SportsRelatedBusinessController());

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
                          return Container();
                        }
                        SlotUnavailable? slotUnavailable =
                            slotUnavaliableList.firstWhereOrNull(
                                (element) => element.slot == index);
                        if (slotUnavailable != null) {
                          return ListTile(
                            title: Text('$index:00 - $index:59'),
                            subtitle: const Text('UNAVAILABLE'),
                            enabled: false,
                          );
                        }
                        if (listingController.selectedDate.value.day ==
                                DateTime.now().day &&
                            index <= DateTime.now().hour + 1) {
                          return ListTile(
                            title: Text('$index:00 - $index:59'),
                            enabled: false,
                          );
                        }
                        return ListTile(
                          title: Text('$index:00 - $index:59'),
                          subtitle: const Text('AVAILABLE'),
                          enableFeedback: true,
                          onTap: () {
                            SharedDialog.confirmationDialog(
                                title: 'Confirmation',
                                message:
                                    'Are you sure to make appointment as detail below:\n${listingController.selectedSF!.facilityName} \n$index:00 - $index:59',
                                onOK: () async {
                                  if (listingController.isMakeAppointment) {
                                    await listingController.makeAppointment(
                                        index,
                                        sportsRelatedBusinessController
                                            .selectedSRB!);
                                    Get.offAll(()=>ViewSportsActivityPage());
                                  } else {
                                    Appointment appointment = listingController
                                        .initAppointment(index);
                                    sportsActivityController.setAppointment(
                                        appointment,
                                        sportsRelatedBusinessController
                                            .selectedSRB!,
                                        '${listingController.selectedSF!.facilityName} \n$index:00 - $index:59');
                                    Get.close(3);
                                  }
                                },
                                onCancel: () {});
                          },
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
