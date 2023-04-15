import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jomsports/shared/constant/asset.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/navigation_bar.dart/admin_nav_bar.dart';
import 'package:jomsports/shared/widget/navigation_bar.dart/sports_lover_nav_bar.dart';
import 'package:jomsports/shared/widget/navigation_bar.dart/sports_related_business_nav_bar.dart';

class DefaultScaffold extends StatelessWidget {
  DefaultScaffold(
      {super.key,
      required this.body,
      required this.title,
      this.back = true,
      required this.role});

  final Widget body;
  final String title;
  final bool back;
  final Role role;

  RxDouble widgetHeight = RxDouble(160);
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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BackButton(),
          Flexible(
            child: SingleChildScrollView(
              child: Center(child: body),
            ),
          ),
        ],
      ),
      bottomNavigationBar: navBar,
    );
  }

  void initScaffold() {
    switch (role) {
      case Role.sportsLover:
        navBar = const SportsLoverNavBar(currentIndex: 0);
        break;
      case Role.sportsRelatedBusiness:
        navBar = const SportsRelatedBusinessNavBar(currentIndex: 0);
        break;
      case Role.admin:
        navBar = const AdminNavBar(currentIndex: 0);
        break;
      case Role.notLoginned:
        navBar = null;
        break;
    }
  }
}
