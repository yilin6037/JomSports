import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/shared/constant/textformfield_validator.dart';

class SharedTextFormField extends StatelessWidget {
  const SharedTextFormField(
      {Key? key,
      this.controller,
      this.hintText,
      this.labelText,
      this.initialValue,
      this.obscureText = false,
      this.keyboard = TextInputType.text,
      this.errorText = 'This field is required',
      this.validator = ValidatorType.none,
      this.enabled = true})
      : super(key: key);
  final TextEditingController? controller;
  final String? hintText; //placeholder
  final String? labelText; //label
  final String errorText; //text shown for error
  final bool obscureText; //hide the input
  final TextInputType?
      keyboard; //type of input (TextInputType.number / TextInputType.text)
  final String? initialValue;
  final ValidatorType validator;
  final enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboard,
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      enabled: enabled,
      validator: (value) {
        if (value != null) {
          switch (validator) {
            case ValidatorType.none:
              break;
            case ValidatorType.required:
              if (value == '') {
                return 'This field is required';
              }
              break;
            case ValidatorType.email:
              if (value == '') {
                return 'This field is required';
              }
              if (!GetUtils.isEmail(value)) {
                return 'Please enter a valid email.';
              }
              break;
            case ValidatorType.phoneNo:
              if(value == ''){
                return 'This field is required';
              }
              if(!GetUtils.isPhoneNumber(value)){
                return 'Please enter a valid phone no. (0123456789)';
              }
              break;
          }
        }

        return null;
      },
    );
  }
}
