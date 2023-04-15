import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jomsports/models/sports_lover.dart';
import 'package:jomsports/models/sports_related_business.dart';
import 'package:jomsports/models/user.dart';

class UserServiceFirebase {
  final firestoreInstance = FirebaseFirestore.instance;

  Future createUser(User user) async {
    return await firestoreInstance
        .collection('User')
        .doc(user.userID)
        .set(user.toJson());
  }

  Future createSportsLover(SportsLover sportsLover) async {
    createUser(sportsLover);
    return await firestoreInstance
        .collection('SportsLover')
        .doc(sportsLover.userID)
        .set(sportsLover.toJsonSportsLover());
  }

  Future createSportsRelatedBusiness(
      SportsRelatedBusiness sportsRelatedBusiness) async {
    createUser(sportsRelatedBusiness);
    return await firestoreInstance
        .collection('SportsRelatedBusiness')
        .doc(sportsRelatedBusiness.userID)
        .set(sportsRelatedBusiness.toJsonSportsRelatedBusiness());
  }

  Future<User> getUser(String userID) async {
    User user;

    final snapshot =
        await FirebaseFirestore.instance.collection('User').doc(userID).get();
    user = User.fromJson(snapshot.data());
    user.userID = userID;

    return user;
  }

  Future<SportsLover> getSportsLover(String userID) async {
    SportsLover sportsLover;

    final snapshot = await FirebaseFirestore.instance
        .collection('SportsLover')
        .doc(userID)
        .get();
    sportsLover = SportsLover.fromJsonSportsLover(snapshot.data());
    sportsLover.userID = userID;

    return sportsLover;
  }

  Future<SportsRelatedBusiness> getSportsRelatedBusiness(String userID) async {
    SportsRelatedBusiness sportsRelatedBusiness;

    final snapshot = await FirebaseFirestore.instance
        .collection('SportsRelatedBusiness')
        .doc(userID)
        .get();
    sportsRelatedBusiness =
        SportsRelatedBusiness.fromJsonSportsRelatedBusiness(snapshot.data());
    sportsRelatedBusiness.userID = userID;

    return sportsRelatedBusiness;
  }

  Future updateUser(User user) async {
    return await firestoreInstance
        .collection('User')
        .doc(user.userID)
        .update(user.toJson());
  }

  Future updateSportsLover(SportsLover sportsLover) async {
    createUser(sportsLover);
    return await firestoreInstance
        .collection('SportsLover')
        .doc(sportsLover.userID)
        .update(sportsLover.toJsonSportsLover());
  }

  Future updateSportsRelatedBusiness(
      SportsRelatedBusiness sportsRelatedBusiness) async {
    createUser(sportsRelatedBusiness);
    return await firestoreInstance
        .collection('SportsRelatedBusiness')
        .doc(sportsRelatedBusiness.userID)
        .update(sportsRelatedBusiness.toJsonSportsRelatedBusiness());
  }
}
