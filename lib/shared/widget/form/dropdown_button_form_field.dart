import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class SharedDropdownButtonFormField<T> extends StatelessWidget {
  const SharedDropdownButtonFormField(
      {super.key,
      this.hint = 'Please select one.',
      this.value,
      required this.items,
      required this.onChanged,
      required this.onSaved});

  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final Function(T?) onSaved;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      items: items,
      hint: Text(hint),
      validator: (value) {
        if (value == null) {
          return 'This field is required';
        }
        return null;
      },
      value: value,
      onChanged: onChanged,
      onSaved: onSaved,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      dropdownStyleData: DropdownStyleData(
          maxHeight: MediaQuery.of(context).size.height * 0.3,
          offset: const Offset(0, -15)),
    );
  }
}
