import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:jomsports/shared/constant/date.dart';

class SharedDateTimePicker extends StatelessWidget {
  const SharedDateTimePicker(
      {super.key,
      this.firstDate,
      this.lastDate,
      required this.onChanged,
      required this.onSaved,
      this.value, this.textEditingController});

  final String? value;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(String?) onChanged;
  final Function(String?) onSaved;
  final TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context) {
    return DateTimePicker(
      type: DateTimePickerType.dateTime,
      dateMask: DateConstant.dateFormat,
      icon: const Icon(Icons.event),
      initialValue: value,
      controller: textEditingController,
      firstDate: firstDate,
      lastDate: lastDate,
      validator: (value) {
        if (value == null || value == '') {
          return 'This field is required';
        }
        return null;
      },
      autovalidate: true,
      onChanged: onChanged,
      onSaved: onSaved,
    );
  }
}
