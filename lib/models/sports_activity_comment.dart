import 'package:jomsports/models/user.dart';
import 'package:jomsports/services/sports_activity_service_firebase.dart';

class SportsActivityComment {
  String saCommentID;
  String content;
  String dateTime;
  String saID;
  User user;

  SportsActivityComment({
    required this.saCommentID,
    required this.content,
    required this.dateTime,
    required this.saID,
    required this.user,
  });

  Map<String, dynamic> toJson() => {
        'saCommentID': saCommentID,
        'content': content,
        'dateTime': dateTime,
        'saID': saID,
        'userID': user.userID,
      };

  SportsActivityComment.fromJson(
      String saCommentID, User user, Map<String, dynamic>? json)
      : this(
          saCommentID: saCommentID,
          content: json?['content'],
          dateTime: json?['dateTime'],
          saID: json?['saID'],
          user: user,
        );

  static Stream<List<SportsActivityComment>> getCommentList(String saID) {
    SportsActivityServiceFirebase sportsActivityServiceFirebase =
        SportsActivityServiceFirebase();

    return sportsActivityServiceFirebase.getCommentList(saID);
  }

  Future comment() async {
    SportsActivityServiceFirebase sportsActivityServiceFirebase =
        SportsActivityServiceFirebase();
    await sportsActivityServiceFirebase.createComment(this);
  }
}
