class Appointment {
  String appointmentID;
  String date;
  int slot;
  String userID;
  String listingID;
  String saID;

  Appointment(
      {required this.appointmentID,
      required this.date,
      required this.slot,
      required this.userID,
      required this.listingID,
      required this.saID});

  Map<String, dynamic> toJson() => {
        'date': date,
        'slot': slot,
        'userID': userID,
        'listingID': listingID,
        'saID': saID,
      };

  Appointment.fromJson(String appointmentID, Map<String, dynamic>? json)
      : this(
          appointmentID: appointmentID,
          date: json?['date'],
          slot: json?['slot'],
          userID: json?['userID'],
          listingID: json?['listingID'],
          saID: json?['saID'],
        );
}
