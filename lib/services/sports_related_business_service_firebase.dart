import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jomsports/models/appointment.dart';
import 'package:jomsports/shared/constant/firestore.dart';

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
}
