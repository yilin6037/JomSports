import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/controllers/sports_related_business_controller.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/constant/sports.dart';
import 'package:jomsports/shared/constant/textformfield_validator.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/shared/widget/form/date_time_picker.dart';
import 'package:jomsports/shared/widget/form/dropdown_button_form_field.dart';
import 'package:jomsports/shared/widget/form/map_location_picker.dart';
import 'package:jomsports/shared/widget/form/textformfield.dart';
import 'package:jomsports/views/sports_activity/make_appointment/make_appointment_page.dart';

class SportsActivityForm extends StatelessWidget {
  SportsActivityForm({super.key, required this.onSubmitted});

  final SportsActivityController sportsActivityController =
      Get.find(tag: 'sportsActivityController');
  RxString mapValidationMessage = RxString('');
  final Function() onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: sportsActivityController.organizeFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Obx(() {
        Rx<DateTime> finalDate =
            Rx<DateTime>(DateTime.now().add(const Duration(days: 7)));
        Rx<DateTime> firstDate = Rx<DateTime>(DateTime.now());
        if (sportsActivityController.appointment != null) {
          finalDate.value =
              DateTime.parse(sportsActivityController.appointment!.date).add(
                  Duration(hours: sportsActivityController.appointment!.slot));
          firstDate.value =
              DateTime.parse(sportsActivityController.appointment!.date);
        }
        return Column(
          children: [
            //sports type
            SharedDropdownButtonFormField<SportsType>(
              hint: 'Sports Type',
              value: sportsActivityController.sportsTypeValue,
              items: SportsType.values
                  .map((sportsType) => DropdownMenuItem(
                        value: sportsType,
                        child: Text(sportsType.sportsName),
                      ))
                  .toList(),
              onChanged: (value) {
                sportsActivityController.sportsTypeValue = value;
              },
              onSaved: (value) {},
            ),

            //date time
            SharedDateTimePicker(
                firstDate: firstDate.value,
                lastDate: finalDate.value,
                textEditingController:
                    sportsActivityController.dateTimeTextEditingController,
                onChanged: (value) {},
                onSaved: (value) {}),

            //max participants
            SharedTextFormField(
                controller:
                    sportsActivityController.maxParticipantsTextController,
                labelText: 'Max Participants',
                hintText: 'Please enter the maximum number of participants',
                keyboard: const TextInputType.numberWithOptions(
                    signed: false, decimal: false),
                validator: ValidatorType.integer),

            //description
            SharedTextFormField(
              controller: sportsActivityController.descriptionTextController,
              keyboard: TextInputType.multiline,
              labelText: 'Description',
              hintText: 'Please enter the description of the activity',
              validator: ValidatorType.required,
              maxLines: 3,
            ),

            //address
            SharedTextFormField(
              controller: sportsActivityController.addressTextController,
              enabled: false,
              labelText: 'Please locate your address on the map',
              validator: ValidatorType.required,
            ),
            if (sportsActivityController.appointment == null)
              SharedMapLocationPicker(
                currentLat: sportsActivityController.lat.value,
                currentLon: sportsActivityController.lon.value,
                onPickLocation: (address, lat, lon) {
                  if (sportsActivityController.appointment == null) {
                    mapValidationMessage.value = '';
                    sportsActivityController.onPickLocation(address, lat, lon);
                  }
                },
              ),

            Text(
              mapValidationMessage.value,
              style: const TextStyle(color: Color(ColorConstant.dangerText)),
            ),

            sportsActivityController.appointment == null
                ? const Text('or')
                : const Text(
                    'Appointment Detail',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

            //make appointment
            Text(
              sportsActivityController.appointmentDetail.value,
              textAlign: TextAlign.center,
            ),
            SharedButton(
                onPressed: () async {
                  final SportsRelatedBusinessController
                      sportsRelatedBusinessController = Get.put(
                          tag: 'sportsRelatedBusinessController',
                          SportsRelatedBusinessController());
                  await sportsRelatedBusinessController.initMap();
                  Get.to(() => MakeAppointmentPage());
                },
                text: sportsActivityController.appointment == null
                    ? 'Make Appointment'
                    : 'Edit Appointment'),

            const SizedBox(
              height: 10,
            ),

            //organize
            SharedButton(
                onPressed: () async {
                  if (sportsActivityController.organizeFormKey.currentState!
                      .validate()) {
                    onSubmitted();
                  }
                  if (sportsActivityController
                      .addressTextController.text.isEmpty) {
                    mapValidationMessage.value =
                        'Please locate the location and tap on the add location icon';
                  } else {
                    mapValidationMessage.value = '';
                  }
                },
                text: 'Organize')
          ],
        );
      }),
    );
  }
}
