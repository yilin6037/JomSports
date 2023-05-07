import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jomsports/controllers/sports_activity_controller.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/models/sports_activity_comment.dart';
import 'package:jomsports/models/user.dart';
import 'package:jomsports/shared/constant/firestore.dart';
import 'package:jomsports/shared/constant/join_status.dart';
import 'package:jomsports/shared/constant/sports.dart';
import 'package:jomsports/views/sports_activity/view_sports_activity/view_sports_activity_page.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'dart:ui' as ui;
import 'dart:async';

class SportsActivityServiceFirebase {
  final firestoreInstance = FirebaseFirestore.instance;

  Future<String> createSportsActivity(SportsActivity sportsActivity) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.sportsActivity)
        .add(sportsActivity.toJson())
        .then((value) => value.id);
  }

  Stream<List<Marker>> getSportsActivityMarkerList(
      {required double lat,
      required double lon,
      List<SportsType>? preferenceSports,
      List<String>? followedFriends}) {
    var snapshot = firestoreInstance
        .collection(FirestoreCollectionConstant.sportsActivity)
        .snapshots();

    return snapshot.asyncMap((snapshot) async {
      List<Marker> markerList = [];

      for (var doc in snapshot.docs) {
        SportsActivity sportsActivity =
            SportsActivity.fromJson(doc.id, doc.data());
        if (isWithinDistance(
                lat, sportsActivity.lat, lon, sportsActivity.lon) &&
            isWithinDate(sportsActivity.dateTime)) {
          bool isToBeAdded = true;
          if (preferenceSports != null && preferenceSports.isNotEmpty) {
            if (!preferenceSports.contains(sportsActivity.sportsType)) {
              isToBeAdded = false;
            }
          }
          if (followedFriends != null && followedFriends.isNotEmpty) {
            final participantsIDList =
                await getParticipantIDList(sportsActivity.saID);
            isToBeAdded = false;
            for (var participantID in participantsIDList) {
              if (followedFriends.contains(participantID)) {
                isToBeAdded = true;
              }
            }
          }
          if (isToBeAdded) {
            markerList.add(await initMarker(sportsActivity));
          }
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

  bool isWithinDate(String datetime) {
    DateTime today = DateTime.now();
    DateTime dateTime = DateTime.parse(datetime);
    return dateTime.isAfter(today);
  }

  Future<Marker> initMarker(SportsActivity sportsActivity) async {
    final SportsActivityController sportsActivityController =
        Get.put(tag: 'sportsActivityController', SportsActivityController());
    return Marker(
      markerId: MarkerId(sportsActivity.saID),
      position: LatLng(sportsActivity.lat, sportsActivity.lon),
      infoWindow: InfoWindow(
          title: sportsActivity.sportsType.sportsName,
          snippet: sportsActivity.dateTime,
          onTap: () async {
            await sportsActivityController
                .initSportsActivity(sportsActivity.saID);
            Get.to(() =>ViewSportsActivityPage());
          }),
      icon: BitmapDescriptor.fromBytes(
          await getBytesFromAsset(sportsActivity.sportsType.mapMarker, 200)),
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

  Future<SportsActivity?> readSportsActivity(String docid) async {
    final snapshot = await firestoreInstance
        .collection(FirestoreCollectionConstant.sportsActivity)
        .doc(docid)
        .get();
    if (snapshot.exists) {
      return SportsActivity.fromJson(docid, snapshot.data()!);
    } else {
      return null;
    }
  }

  Stream<List<User>> getParticipants(String saID) {
    return firestoreInstance
        .collection(FirestoreCollectionConstant.joinSportsActivity)
        .where('saID', isEqualTo: saID)
        .snapshots()
        .asyncMap((snapshot) async {
      List<User> participants = [];
      for (var doc in snapshot.docs) {
        User participant = await User.getUser(doc.data()['userID']);
        await participant.getProfilePicUrl();
        participants.add(participant);
      }

      return participants;
    });
  }

  Future<List<String>> getParticipantIDList(String saID) async {
    final docs = await firestoreInstance
        .collection(FirestoreCollectionConstant.joinSportsActivity)
        .where('saID', isEqualTo: saID)
        .get();
    List<String> participantsID = [];
    for (var doc in docs.docs) {
      participantsID.add(doc.data()['userID']);
    }
    return participantsID;
  }

  Future joinSportsActivity(String userID, String saID) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.joinSportsActivity)
        .add({'userID': userID, 'saID': saID});
  }

  Future leaveSportsActivity(String userID, String saID) async {
    var id = await firestoreInstance
        .collection(FirestoreCollectionConstant.joinSportsActivity)
        .where('saID', isEqualTo: saID)
        .snapshots()
        .asyncMap((snapshot) async {
      if (snapshot.docs.length == 1) {
        await firestoreInstance
            .collection(FirestoreCollectionConstant.sportsActivity)
            .doc(saID)
            .delete();
      }
      for (var doc in snapshot.docs) {
        if (userID == doc['userID']) {
          return doc.id;
        }
      }
    }).first;

    return await firestoreInstance
        .collection(FirestoreCollectionConstant.joinSportsActivity)
        .doc(id)
        .delete();
  }

  Stream<JoinStatus> isJoined(String saID, String userID) {
    return firestoreInstance
        .collection(FirestoreCollectionConstant.joinSportsActivity)
        .where('saID', isEqualTo: saID)
        .snapshots()
        .asyncMap((snapshot) async {
      final SportsActivity? sportsActivity = await readSportsActivity(saID);
      if (sportsActivity == null) {
        return JoinStatus.unavailable;
      } else if (DateTime.parse(sportsActivity.dateTime)
          .isBefore(DateTime.now())) {
        return JoinStatus.unavailable;
      }
      for (var doc in snapshot.docs) {
        if (doc.data()['userID'] == userID) {
          return JoinStatus.joined;
        }
      }
      if (snapshot.size >= sportsActivity.maxParticipants) {
        return JoinStatus.full;
      }
      return JoinStatus.available;
    });
  }

  Stream<List<SportsActivityComment>> getCommentList(String saID) {
    return firestoreInstance
        .collection(FirestoreCollectionConstant.sportsActivityComment)
        .where('saID', isEqualTo: saID)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<SportsActivityComment> commentList = [];
      for (var doc in snapshot.docs) {
        User user = await User.getUser(doc.data()['userID']);
        commentList
            .add(SportsActivityComment.fromJson(doc.id, user, doc.data()));
      }
      return commentList;
    });
  }

  Future createComment(SportsActivityComment comment) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.sportsActivityComment)
        .add(comment.toJson());
  }

  Stream<List<SportsActivity>> getUpcomingSportsActivities(String userID) {
    return firestoreInstance
        .collection(FirestoreCollectionConstant.joinSportsActivity)
        .where('userID', isEqualTo: userID)
        .snapshots()
        .asyncMap((snapshot) async {
      List<SportsActivity> sportsActivityList = [];

      for (var doc in snapshot.docs) {
        SportsActivity? sportsActivity =
            await SportsActivity.getSportsActivity(doc.data()['saID']);
        if (sportsActivity == null) {
          continue;
        }
        if (isWithinDate(sportsActivity.dateTime)) {
          sportsActivityList.add(sportsActivity);
        }
      }
      sportsActivityList.sort((a, b) =>
          DateTime.parse(a.dateTime).compareTo(DateTime.parse(b.dateTime)));
      return sportsActivityList;
    });
  }
}
