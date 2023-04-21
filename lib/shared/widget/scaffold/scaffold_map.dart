import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/shared/constant/asset.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/navigation_bar.dart/admin_nav_bar.dart';
import 'package:jomsports/shared/widget/navigation_bar.dart/sports_lover_nav_bar.dart';
import 'package:jomsports/shared/widget/navigation_bar.dart/sports_related_business_nav_bar.dart';

class MapScaffold extends StatelessWidget {
  MapScaffold(
      {super.key,
      required this.children,
      required this.title,
      this.back = true,
      required this.role,
      required this.navIndex});

  final List<Widget> children;
  final String title;
  final bool back;
  final Role role;
  final int navIndex;
  Widget? navBar;

  @override
  Widget build(BuildContext context) {
    initScaffold();
    return Scaffold(
      backgroundColor: const Color(ColorConstant.scaffoldBackgroundColor),
      appBar: AppBar(
        backgroundColor: const Color(ColorConstant.appBarBackgroundColor),
        leading: Image.asset(AssetConstant.logo),
        leadingWidth: 125,
        toolbarHeight: 75,
        title: RichText(
          text: TextSpan(
              text: title,
              style: const TextStyle(color: Colors.black, fontSize: 25)),
        ),
      ),
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          ...children
        ],
      ),
      bottomNavigationBar: navBar,
    );
  }

  void initScaffold() {
    switch (role) {
      case Role.sportsLover:
        navBar = SportsLoverNavBar(currentIndex: navIndex);
        break;
      case Role.sportsRelatedBusiness:
        navBar = SportsRelatedBusinessNavBar(currentIndex: navIndex);
        break;
      case Role.admin:
        navBar = AdminNavBar(currentIndex: navIndex);
        break;
      case Role.notLoginned:
        navBar = null;
        break;
    }
  }
}
