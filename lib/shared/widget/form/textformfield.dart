import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/shared/constant/textformfield_validator.dart';

class SharedTextFormField extends StatelessWidget {
  const SharedTextFormField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.initialValue,
    this.obscureText = false,
    this.keyboard = TextInputType.text,
    this.errorText = 'This field is required',
    this.validator = ValidatorType.none,
    this.enabled = true,
    this.maxLines = 1,
  }) : super(key: key);
  final TextEditingController? controller;
  final String? hintText; //placeholder
  final String? labelText; //label
  final String errorText; //text shown for error
  final bool obscureText; //hide the input
  final TextInputType?
      keyboard; //type of input (TextInputType.number / TextInputType.text)
  final String? initialValue;
  final ValidatorType validator;
  final bool enabled;
  final int maxLines;

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
              if (value == '') {
                return 'This field is required';
              }
              if (!GetUtils.isPhoneNumber(value)) {
                return 'Please enter a valid phone no. (0123456789)';
              }
              break;
            case ValidatorType.integer:
              if (value == '') {
                return 'This field is required';
              }
              if (!GetUtils.isNumericOnly(value)) {
                return 'Please enter numeric number';
              }
              break;
            case ValidatorType.hour:
              if (value == '') {
                return 'This field is required';
              }
              if (!GetUtils.isNumericOnly(value)) {
                return 'Not a valid hour';
              }
              if (int.parse(value) < 0 || int.parse(value) > 24) {
                return 'Not a valid hour';
              }
              break;
            case ValidatorType.password:
              if (value == '') {
                return 'This field is required';
              }
              if (GetUtils.isLengthLessThan(value, 6)) {
                return 'Password should be at least 6 characters.';
              }
              break;
          }
        }

        return null;
      },
      maxLines: maxLines,
    );
  }
}
