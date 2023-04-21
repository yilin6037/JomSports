import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/shared/constant/firestore.dart';

class SportsActivityServiceFirebase {
  final firestoreInstance = FirebaseFirestore.instance;

  Future createSportsActivity(SportsActivity sportsActivity) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.sportsActivity)
        .add(sportsActivity.toJson());
  }
}
