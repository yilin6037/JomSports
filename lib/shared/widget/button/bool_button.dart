import 'package:flutter/material.dart';
import 'package:jomsports/shared/constant/color.dart';

class SharedBoolButton extends StatelessWidget {
  SharedBoolButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.disable = false,
      this.fontSize = 12,
      required this.tapped,
      this.width});
  final Function() onPressed;
  final String text;
  final bool tapped;
  final bool disable;
  final double fontSize;
  double? width;

  @override
  Widget build(BuildContext context) {
    var backgroundColor = tapped
        ? ColorConstant.buttonBackgroundColor
        : ColorConstant.notSelectedColor;
    var textColor = tapped
        ? ColorConstant.buttonTextColor
        : ColorConstant.notSelectedTextColor;
    return ElevatedButton(
        onPressed: disable ? null : onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(backgroundColor),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            fixedSize: width != null ? Size.fromWidth(width!) : null),
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize, color: Color(textColor)),
          textAlign: TextAlign.center,
        ));
  }
}
