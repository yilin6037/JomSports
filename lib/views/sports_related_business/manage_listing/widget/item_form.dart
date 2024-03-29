import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/listing_controller.dart';
import 'package:jomsports/shared/constant/textformfield_validator.dart';
import 'package:jomsports/shared/widget/button/button.dart';
import 'package:jomsports/shared/widget/form/textformfield.dart';

class ItemForm extends StatelessWidget {
  ItemForm({super.key, required this.buttonText, required this.onSubmitted, required this.formKey});

  final ListingController listingController =
      Get.find(tag: 'listingController');
  final String buttonText;
  final Function() onSubmitted;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SharedTextFormField(
            controller: listingController.itemNameTextController,
            labelText: 'Name',
            hintText: 'Please enter the name of the item',
            validator: ValidatorType.required,
          ),
          SharedTextFormField(
            controller:
                listingController.itemDescriptionTextController,
            labelText: 'Description',
            hintText: 'Please describe the item',
            validator: ValidatorType.required,
            maxLines: 3,
            keyboard: TextInputType.multiline,
          ),
          Obx(() => CheckboxListTile(
            title: const Text('Availability'),
            value: listingController.itemAvailability.value,
            onChanged: (value) {
              if (value != null) {
                listingController.itemAvailability.value = value;
              }
            },
          )),
          // submit button
          SharedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  onSubmitted();
                }
              },
              text: buttonText)
        ],
      ),
    );
  }
}
