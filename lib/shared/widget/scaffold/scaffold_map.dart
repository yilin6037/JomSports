import 'package:flutter/material.dart';
import 'package:jomsports/shared/constant/asset.dart';
import 'package:jomsports/shared/constant/color.dart';
import 'package:jomsports/shared/constant/map.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/navigation_bar.dart/admin_nav_bar.dart';
import 'package:jomsports/shared/widget/navigation_bar.dart/sports_lover_nav_bar.dart';
import 'package:jomsports/shared/widget/navigation_bar.dart/sports_related_business_nav_bar.dart';
import 'package:map_location_picker/map_location_picker.dart';

class MapScaffold extends StatelessWidget {
  MapScaffold(
      {super.key,
      required this.children,
      required this.title,
      this.back = true,
      required this.role,
      required this.navIndex,
      this.currentLatLng =
          const LatLng(MapConstant.defaultLat, MapConstant.defaultLon),
      required this.stream});

  final List<Widget> children;
  final String title;
  final bool back;
  final Role role;
  final int navIndex;
  Widget? navBar;
  final LatLng currentLatLng;
  final Stream<List<Marker>> stream;

  @override
  Widget build(BuildContext context) {
    initScaffold();
    final currentLocationCamera = CameraPosition(
      target: currentLatLng,
      zoom: 14.4746,
    );
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
          StreamBuilder<List<Marker>>(
            stream: stream,
            builder: (context, snapshot) => GoogleMap(
              initialCameraPosition: currentLocationCamera,
              rotateGesturesEnabled: true,
              tiltGesturesEnabled: false,
              mapToolbarEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              markers: Set<Marker>.of(snapshot.data ?? []),
            ),
          ),
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
