import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/controllers/sports_related_business_controller.dart';
import 'package:jomsports/models/appointment.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/models/sports_related_business.dart';
import 'package:jomsports/models/user.dart';
import 'package:jomsports/shared/constant/asset.dart';
import 'package:jomsports/shared/constant/firestore.dart';
import 'package:jomsports/views/sports_activity/view_sports_activity/view_sports_activity_page.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'dart:ui' as ui;

class SportsRelatedBusinessServiceFirebase {
  final firestoreInstance = FirebaseFirestore.instance;

  Future<Appointment?> readAppointment(String appointmentID) async {
    final snapshot = await firestoreInstance
        .collection(FirestoreCollectionConstant.appointment)
        .doc(appointmentID)
        .get();

    if (snapshot.exists) {
      return Appointment.fromJson(snapshot.id, snapshot.data());
    } else {
      return null;
    }
  }

  Stream<List<Marker>> getSportsRelatedBusinessMarkerList(
      {required double lat, required double lon, required Function(SportsRelatedBusiness) onTap}) {
    var snapshot = firestoreInstance
        .collection(FirestoreCollectionConstant.sportsRelatedBusiness)
        .snapshots();

    return snapshot.asyncMap((snapshot) async {
      List<Marker> markerList = [];

      for (var doc in snapshot.docs) {
        if (isWithinDistance(lat, doc['lat'], lon, doc['lon'])) {
          SportsRelatedBusiness sportsRelatedBusiness =
              await User.getUser(doc.id);
          await sportsRelatedBusiness.getProfilePicUrl();
          markerList.add(await initMarker(sportsRelatedBusiness, onTap));
        }
      }

      return markerList;
    });
  }

  bool isWithinDistance(
      double centerLat, double lat, double centerLon, double lon) {
    return (lat >= (centerLat - 1.5) &&
        lat <= (centerLat + 1.5) &&
        lon >= (centerLon - 1.5) &&
        lon <= (centerLon + 1.5));
  }

  Future<Marker> initMarker(SportsRelatedBusiness sportsRelatedBusiness, Function(SportsRelatedBusiness) onTap) async {
    final SportsRelatedBusinessController sportsRelatedBusinessController =
        Get.put(tag: 'sportsRelatedBusinessController', SportsRelatedBusinessController());
    return Marker(
      markerId: MarkerId(sportsRelatedBusiness.userID),
      position: LatLng(sportsRelatedBusiness.lat, sportsRelatedBusiness.lon),
      infoWindow: InfoWindow(
          title: sportsRelatedBusiness.name,
          snippet: sportsRelatedBusiness.authenticationStatus.authenticationText,
          onTap: () {
            onTap(sportsRelatedBusiness);
          }),
      icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset(AssetConstant.shop, 200)),
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);

    ui.FrameInfo fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
