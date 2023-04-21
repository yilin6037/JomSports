import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/shared/constant/asset.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/navigation_bar.dart/admin_nav_bar.dart';
import 'package:jomsports/shared/widget/navigation_bar.dart/sports_lover_nav_bar.dart';
import 'package:jomsports/shared/widget/navigation_bar.dart/sports_related_business_nav_bar.dart';

class SimpleScaffold extends StatelessWidget {
  const SimpleScaffold({super.key, required this.body, required this.role, required this.navIndex});

  final Widget body;
  final Role role;
  final int navIndex;

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
            title: Image.asset(AssetConstant.logo)),
      body: body,
      bottomNavigationBar:bottomNavigationBar(),
    );
  }

  Widget? bottomNavigationBar(){
    switch (role){
      case Role.sportsLover:
        return SportsLoverNavBar(currentIndex: navIndex);
      case Role.sportsRelatedBusiness:
        return SportsRelatedBusinessNavBar(currentIndex: navIndex);
      case Role.admin:
        return AdminNavBar(currentIndex: navIndex);
      case Role.notLoginned:
        return null;
    }
  }
}