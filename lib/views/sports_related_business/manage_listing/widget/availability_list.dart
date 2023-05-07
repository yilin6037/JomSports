import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/models/slot_unavailable.dart';

class AvailabilityListWidget extends StatelessWidget {
  AvailabilityListWidget({super.key});

  final ListingController listingController =
      Get.find(tag: 'listingController');

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
                                index >
                                    listingController
                                        .selectedSF!
                                        .operatingHourList[listingController
                                                .selectedDate.value.weekday -
                                            1]
                                        .closeHour) {
                              return ListTile(
                                title: Text('$index:00 - $index:59'),
                                enabled: false,
                              );
                            }
                            SlotUnavailable? slotUnavailable =
                                slotUnavaliableList.firstWhereOrNull(
                                    (element) => element.slot == index);
                            if (slotUnavailable != null) {
                              return ListTile(
                                title: Text('$index:00 - $index:59'),
                                subtitle: slotUnavailable.appointment != null
                                    ? TextButton(
                                        child: Text(
                                            'Sports Activity ${slotUnavailable.appointment!.listingID}'),
                                        onPressed: () {},
                                      )
                                    : null,
                                trailing: slotUnavailable.appointment == null
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
