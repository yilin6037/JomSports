import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/shared/constant/date.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/form/dropdown_button_form_field.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:jomsports/views/sports_related_business/manage_listing/widget/availability_list.dart';

class AvailabilityPage extends StatelessWidget {
  AvailabilityPage({super.key});

  final ListingController listingController =
      Get.find(tag: 'listingController');

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: 'Availability of ${listingController.selectedSF!.facilityName}',
      role: Role.sportsRelatedBusiness,
      navIndex: 1,
      scrollable: false,
      body: Stack(
        children: [
          AvailabilityListWidget(),
          Positioned(
            top: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: SharedDropdownButtonFormField<DateTime>(
                    hint: 'Date',
                    value: listingController.selectedDate.value,
                    items: listingController.upcomingWeek
                        .map((date) => DropdownMenuItem(
                              value: date,
                              child: Text(
                                  '${date.toString().substring(0, 10)} (${Day.values[date.weekday - 1].full})'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        listingController.selectedDate.value = value;
                      }
                    },
                    onSaved: (value) {},
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
