import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/constant/sports.dart';
import 'package:jomsports/shared/constant/textformfield_validator.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/shared/widget/form/date_time_picker.dart';
import 'package:jomsports/shared/widget/form/dropdown_button_form_field.dart';
import 'package:jomsports/shared/widget/form/map_location_picker.dart';
import 'package:jomsports/shared/widget/form/textformfield.dart';

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
      child: Column(
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
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 7)),
              value: sportsActivityController.dateTimeValue,
              onChanged: (value) {
                sportsActivityController.dateTimeValue = value;
              },
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
          SharedMapLocationPicker(
            currentLat: sportsActivityController.lat.value,
            currentLon: sportsActivityController.lon.value,
            onPickLocation: (address, lat, lon) {
              mapValidationMessage.value = '';
              sportsActivityController.onPickLocation(address, lat, lon);
            },
          ),
          Obx(() => Text(
                mapValidationMessage.value,
                style: const TextStyle(color: Color(ColorConstant.dangerText)),
              )),

          const Text('or'),
          //make appointment
          SharedButton(onPressed: () {}, text: 'Make Appointment'),

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
      ),
    );
  }
}
