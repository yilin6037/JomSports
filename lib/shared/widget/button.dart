import 'package:flutter/material.dart';
import 'package:jomsports/shared/constant/color.dart';

class SharedButton extends StatelessWidget {
  const SharedButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.danger = false,
      this.width = 150,
      this.disable = false,
      this.fontSize = 20});
  final Function() onPressed;
  final String text;
  final bool danger;
  final double width;
  final bool disable;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    var backgroundColor =
        danger ? ColorConstant.danger : ColorConstant.buttonBackgroundColor;
    return ElevatedButton(
        onPressed: disable ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(backgroundColor),
          fixedSize: Size.fromWidth(width),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: fontSize),
          textAlign: TextAlign.center,
        ));
  }
}
