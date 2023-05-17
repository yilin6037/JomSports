import 'package:jomsports/services/sports_related_business_service_firebase.dart';
import 'package:jomsports/shared/constant/appointment_status.dart';

class Appointment {
  String appointmentID;
  String date;
  int slot;
  String listingID;
  String saID;
  AppointmentStatus status;

  Appointment({
    required this.appointmentID,
    required this.date,
    required this.slot,
    required this.listingID,
    required this.saID,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'slot': slot,
        'listingID': listingID,
        'saID': saID,
        'status': status.name
      };

  Appointment.fromJson(String appointmentID, Map<String, dynamic>? json)
      : this(
          appointmentID: appointmentID,
          date: json?['date'],
          slot: json?['slot'],
          listingID: json?['listingID'],
          saID: json?['saID'],
          status: AppointmentStatus.values.byName(json?['status']),
        );

  Future makeAppointment() async {
    SportsRelatedBusinessServiceFirebase sportsRelatedBusinessServiceFirebase =
        SportsRelatedBusinessServiceFirebase();
    sportsRelatedBusinessServiceFirebase.createAppointment(this);
  }

  static Future<List<String>> deleteAppointmentBySaID(String saID) async {
    SportsRelatedBusinessServiceFirebase sportsRelatedBusinessServiceFirebase =
        SportsRelatedBusinessServiceFirebase();
    return await sportsRelatedBusinessServiceFirebase
        .deleteAppointmentBySaID(saID);
  }

  static Stream<List<Appointment>> getAppointmentListBySaID(String saID) {
    SportsRelatedBusinessServiceFirebase sportsRelatedBusinessServiceFirebase =
        SportsRelatedBusinessServiceFirebase();
    return sportsRelatedBusinessServiceFirebase.getAppointmentListBySaID(saID);
  }

  static Future cancelAppointment (String appointmentID) async{
    SportsRelatedBusinessServiceFirebase sportsRelatedBusinessServiceFirebase =
        SportsRelatedBusinessServiceFirebase();
    return sportsRelatedBusinessServiceFirebase.cancelAppointment(appointmentID);
  }
}
