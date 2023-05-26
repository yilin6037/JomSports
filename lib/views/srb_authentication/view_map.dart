import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:jomsports/models/sports_related_business.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/widget/scaffold/scaffold_default.dart';
import 'package:map_location_picker/map_location_picker.dart';

class ViewMap extends StatelessWidget {
  const ViewMap(
      {super.key, required this.srb, required this.onTap, required this.icon});

  final SportsRelatedBusiness srb;
  final Function() onTap;
  final Uint8List icon;

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
      title: srb.name,
      role: Role.admin,
      navIndex: 1,
      scrollable: false,
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(srb.lat, srb.lon),
          zoom: 17,
        ),
        rotateGesturesEnabled: true,
        tiltGesturesEnabled: false,
        mapToolbarEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        markers: <Marker>{
          Marker(
            markerId: MarkerId(
              srb.userID,
            ),
            position: LatLng(srb.lat, srb.lon),
            infoWindow: InfoWindow(
                title: srb.name, snippet: srb.address, onTap: () => onTap()),
            icon: BitmapDescriptor.fromBytes(icon),
          )
        },
      ),
    );
  }
}
