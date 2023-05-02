import 'package:jomsports/models/user.dart';
import 'package:jomsports/services/sports_activity_service_firebase.dart';
import 'package:jomsports/shared/constant/join_status.dart';
import 'package:jomsports/shared/constant/sports.dart';
import 'package:map_location_picker/map_location_picker.dart';

class SportsActivity {
  String saID;
  SportsType sportsType;
  String dateTime;
  int maxParticipants;
  String address;
  double lat;
  double lon;
  String description;

  SportsActivity(
      {required this.saID,
      required this.sportsType,
      required this.dateTime,
      required this.maxParticipants,
      required this.address,
      required this.lat,
      required this.lon,
      required this.description});

  Map<String, dynamic> toJson() => {
        'sportsType': sportsType.name,
        'dateTime': dateTime,
        'maxParticipants': maxParticipants,
        'address': address,
        'lat': lat,
        'lon': lon,
        'description': description,
        
      };

  SportsActivity.fromJson(String saID, Map<String, dynamic>? json)
      : this(
            saID: saID,
            sportsType: SportsType.values.byName(json?['sportsType']),
            dateTime: json?['dateTime'],
            maxParticipants: json?['maxParticipants'],
            address: json?['address'],
            lat: json?['lat'],
            lon: json?['lon'],
            description: json?['description'],
            );

  Future organizeSportsActivity(String userID) async {
    SportsActivityServiceFirebase sportsActivityServiceFirebase =
        SportsActivityServiceFirebase();
    String saID =
        await sportsActivityServiceFirebase.createSportsActivity(this);
    await sportsActivityServiceFirebase.joinSportsActivity(userID, saID);
  }

  static Stream<List<Marker>> getSportsActivityMarkerList(
      {List<SportsType>? preferenceSports,
      List<String>? followedFriends,
      required double lat,
      required double lon}) {
    SportsActivityServiceFirebase sportsActivityServiceFirebase =
        SportsActivityServiceFirebase();
    return sportsActivityServiceFirebase.getSportsActivityMarkerList(
        preferenceSports: preferenceSports,
        followedFriends: followedFriends,
        lat: lat,
        lon: lon);
  }

  static Future<SportsActivity?> getSportsActivity(String saID) {
    SportsActivityServiceFirebase sportsActivityServiceFirebase =
        SportsActivityServiceFirebase();
    return sportsActivityServiceFirebase.readSportsActivity(saID);
  }

  Stream<List<User>> getParticipants() {
    SportsActivityServiceFirebase sportsActivityServiceFirebase =
        SportsActivityServiceFirebase();
    return sportsActivityServiceFirebase.getParticipants(saID);
  }

  Future joinSportsActivity(String userID) async {
    SportsActivityServiceFirebase sportsActivityServiceFirebase =
        SportsActivityServiceFirebase();
    sportsActivityServiceFirebase.joinSportsActivity(userID, saID);
  }

  Future leaveSportsActivity(String userID) async {
    SportsActivityServiceFirebase sportsActivityServiceFirebase =
        SportsActivityServiceFirebase();
    sportsActivityServiceFirebase.leaveSportsActivity(userID, saID);
  }

  Stream<JoinStatus> isJoined(String userID) {
    SportsActivityServiceFirebase sportsActivityServiceFirebase =
        SportsActivityServiceFirebase();
    return sportsActivityServiceFirebase.isJoined(saID, userID);
  }

  static Stream<List<SportsActivity>> getUpcomingSportsActivity (String userID){
    SportsActivityServiceFirebase sportsActivityServiceFirebase =
        SportsActivityServiceFirebase();
    return sportsActivityServiceFirebase.getUpcomingSportsActivities(userID);
  }
}
