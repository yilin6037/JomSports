import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/color.dart';

class SimpleScaffold extends StatelessWidget {
  const SimpleScaffold({super.key, required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    RxDouble height = RxDouble(225);
    var keyboardOn = MediaQuery.of(context).viewInsets.bottom.obs;
    if (keyboardOn.value > 0) {
      height = RxDouble(75);
    } else {
      height = RxDouble(225);
    }
    return Scaffold(
      backgroundColor: const Color(ColorConstant.scaffoldBackgroundColor),
      appBar: AppBar(
            backgroundColor: const Color(ColorConstant.appBarBackgroundColor),
            toolbarHeight: height.value,
            title: Image.asset('assets/logo.png')),
      body: body,
    );
  }
}