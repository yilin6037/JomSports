import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:jomsports/models/appointment.dart';
import 'package:jomsports/models/sports_facility.dart';
import 'package:jomsports/models/sports_related_business.dart';
import 'package:jomsports/models/user.dart';
import 'package:jomsports/shared/constant/appointment_status.dart';
import 'package:jomsports/shared/constant/asset.dart';
import 'package:jomsports/shared/constant/authentication_status.dart';
import 'package:jomsports/shared/constant/firestore.dart';
import 'package:jomsports/shared/widget/chart/piechart.dart';
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

  Future createAppointment(Appointment appointment) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.appointment)
        .doc(appointment.appointmentID)
        .set(appointment.toJson());
  }

  Future cancelAppointment(String appointmentID) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.appointment)
        .doc(appointmentID)
        .update({'status': AppointmentStatus.canceled.name});
  }

  Future<List<String>> deleteAppointmentBySaID(String saID) async {
    final snapshots = await firestoreInstance
        .collection(FirestoreCollectionConstant.appointment)
        .where('saID', isEqualTo: saID)
        .get();

    List<String> idList = [];

    for (var doc in snapshots.docs) {
      await firestoreInstance
          .collection(FirestoreCollectionConstant.appointment)
          .doc(doc.id)
          .delete();
      idList.add(doc.id);
    }

    return idList;
  }

  Stream<List<Appointment>> getAppointmentListBySaID(String saID) {
    return firestoreInstance
        .collection(FirestoreCollectionConstant.appointment)
        .where('saID', isEqualTo: saID)
        .orderBy('status')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Appointment.fromJson(doc.id, doc.data()))
            .toList());
  }

  Stream<List<Appointment>> getUpcomingAppointment(String userID) {
    String today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toString();
    return firestoreInstance
        .collection(FirestoreCollectionConstant.appointment)
        .where('date', isEqualTo: today)
        .orderBy('slot')
        .snapshots()
        .asyncMap((snapshot) async {
      List<SportsFacility> sportsFacilityList =
          await SportsFacility.getSportsFacilityListByUserID(userID);

      List<Appointment> appointmentList = [];

      for (var sportsFacility in sportsFacilityList) {
        appointmentList.addAll(snapshot.docs
            .where((doc) =>
                doc.data()['listingID'] == sportsFacility.listingID &&
                doc.data()['status'] != AppointmentStatus.canceled.name)
            .map((doc) => Appointment.fromJson(doc.id, doc.data()))
            .toList());
      }

      appointmentList.sort((a, b) => a.slot.compareTo(b.slot));
      return appointmentList;
    });
  }

  Stream<List<Marker>> getSportsRelatedBusinessMarkerList(
      {required double lat,
      required double lon,
      required Function(SportsRelatedBusiness) onTap,
      bool isSFOnly = false}) {
    var snapshot = firestoreInstance
        .collection(FirestoreCollectionConstant.sportsRelatedBusiness)
        .snapshots();

    return snapshot.asyncMap((snapshot) async {
      List<Marker> markerList = [];

      for (var doc in snapshot.docs) {
        if (isWithinDistance(lat, doc['lat'], lon, doc['lon'])) {
          if (isSFOnly && !doc['hasSF']) {
            continue;
          }
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

  Future<Marker> initMarker(SportsRelatedBusiness sportsRelatedBusiness,
      Function(SportsRelatedBusiness) onTap) async {
    return Marker(
      markerId: MarkerId(sportsRelatedBusiness.userID),
      position: LatLng(sportsRelatedBusiness.lat, sportsRelatedBusiness.lon),
      infoWindow: InfoWindow(
          title: sportsRelatedBusiness.name,
          snippet:
              sportsRelatedBusiness.authenticationStatus.authenticationText,
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

  Stream<List<SportsRelatedBusiness>> getPendingSRB() {
    return firestoreInstance
        .collection(FirestoreCollectionConstant.sportsRelatedBusiness)
        .where('authenticationStatus',
            isEqualTo: AuthenticationStatus.pending.name)
        .snapshots()
        .asyncMap((snapshot) async {
      List<SportsRelatedBusiness> sportsRelatedBusinessList = [];
      for (var doc in snapshot.docs) {
        SportsRelatedBusiness srb = await User.getUser(doc.id);
        srb.getProfilePicUrl();
        sportsRelatedBusinessList.add(srb);
      }
      return sportsRelatedBusinessList;
    });
  }

  Future changeAuthenticationStatus(
      String userID, AuthenticationStatus authenticationStatus) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.sportsRelatedBusiness)
        .doc(userID)
        .update({'authenticationStatus': authenticationStatus.name});
  }

  Stream<List<ChartData>> getSRBSummary() {
    return firestoreInstance
        .collection(FirestoreCollectionConstant.sportsRelatedBusiness)
        .snapshots()
        .map((snapshot) {
      List<ChartData> chartData = List.generate(
          AuthenticationStatus.values.length,
          (index) =>
              ChartData(AuthenticationStatus.values[index].summaryText, 0));
      for (var doc in snapshot.docs) {
        final index = chartData.indexWhere((element) =>
            element.x ==
            AuthenticationStatus.values
                .byName(doc.data()['authenticationStatus'])
                .summaryText);

        chartData[index].y += 1;
      }
      return chartData;
    });
  }
}
