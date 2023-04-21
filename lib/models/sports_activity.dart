import 'package:jomsports/services/sports_activity_service_firebase.dart';
import 'package:jomsports/shared/constant/sports.dart';

class SportsActivity {
  String saID;
  SportsType sportsType;
  String dateTime;
  int maxParticipants;
  String address;
  double lat;
  double lon;
  String description;
  List<String> participants;

  SportsActivity(
      {required this.saID,
      required this.sportsType,
      required this.dateTime,
      required this.maxParticipants,
      required this.address,
      required this.lat,
      required this.lon,
      required this.description,
      required this.participants});

  Map<String, dynamic> toJson() => {
        'sportsType': sportsType.sportsName,
        'dateTime': dateTime,
        'maxParticipants': maxParticipants,
        'address': address,
        'lat': lat,
        'lon': lon,
        'description': description,
        'participants': participants
      };

  SportsActivity.fromJson(Map<String, dynamic>? json)
      : this(
            saID: '',
            sportsType: SportsType.values.byName(json?['sportsType']),
            dateTime: json?['dateTime'],
            maxParticipants: json?['maxParticipants'],
            address: json?['address'],
            lat: json?['lat'],
            lon: json?['lon'],
            description: json?['description'],
            participants:
                json?['participants'].map<String>((j) => j as String).toList());

  Future organizeSportsActivity() async {
    SportsActivityServiceFirebase sportsActivityServiceFirebase =
        SportsActivityServiceFirebase();
    return await sportsActivityServiceFirebase.createSportsActivity(this);
  }
}
