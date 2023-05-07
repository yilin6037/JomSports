import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/constant/date.dart';
import 'package:jomsports/shared/constant/textformfield_validator.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/shared/widget/form/textformfield.dart';

class SportsFacilityForm extends StatelessWidget {
  SportsFacilityForm(
      {super.key, required this.buttonText, required this.onSubmitted, required this.formKey});

  final ListingController listingController =
      Get.find(tag: 'listingController');

  final String buttonText;
  final Function() onSubmitted;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          SharedTextFormField(
            controller: listingController.facilityNameTextController,
            labelText: 'Name',
            hintText: 'Please enter the name of the sports facility',
            validator: ValidatorType.required,
          ),
          SharedTextFormField(
            controller: listingController.facilityDescriptionTextController,
            labelText: 'Description',
            hintText: 'Please describe the sports facility',
            validator: ValidatorType.required,
            maxLines: 3,
            keyboard: TextInputType.multiline,
          ),

          const SizedBox(
            height: 10,
          ),

          const Text(
            'Operating Hour',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            'Please enter 0 for both Open Hour and Close Hour if it is closed on that day',
            style: TextStyle(fontSize: 12),
          ),

          ListView.builder(
            itemCount: 7,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Text('${Day.values[index].short}: '),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: SharedTextFormField(
                          controller: listingController
                              .openHourTextControllerList[index],
                          labelText: 'Open Hour (0-24)',
                          keyboard: TextInputType.number,
                          validator: ValidatorType.hour,
                        ),
                      ),
                      const Text(' - '),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: SharedTextFormField(
                          controller: listingController
                              .closeHourTextControllerList[index],
                          labelText: 'Close Hour (0-24)',
                          keyboard: TextInputType.number,
                          validator: ValidatorType.hour,
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => Text(
                      listingController.operatingHourErrorMessage[index].value,
                      style: const TextStyle(
                          color: Color(ColorConstant.dangerText), fontSize: 12),
                    ),
                  )
                ],
              );
            },
          ),

          // submit button
          SharedButton(
              onPressed: () {
                if (formKey.currentState!
                    .validate()) {
                  bool isValidate = true;
                  for (var i = 0; i < 7; i++) {
                    if (int.parse(listingController
                            .openHourTextControllerList[i].text) >
                        int.parse(listingController
                            .closeHourTextControllerList[i].text)) {
                      listingController.operatingHourErrorMessage[i].value =
                          'Please enter the Close Hour that is after the Open Hour';
                      isValidate = false;
                    } else {
                      listingController.operatingHourErrorMessage[i].value = '';
                    }
                  }
                  if (isValidate) {
                    onSubmitted();
                  }
                }
              },
              text: buttonText)
        ],
      ),
    );
  }
}
