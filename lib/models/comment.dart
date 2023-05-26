import 'package:jomsports/models/user.dart';
import 'package:jomsports/services/forum_service_firebase.dart';

class Comment {
  String commentID;
  String content;
  String dateTime;
  String postID;
  User user;

  Comment({
    required this.commentID,
    required this.content,
    required this.dateTime,
    required this.postID,
    required this.user,
  });

  Map<String, dynamic> toJson() => {
        'content': content,
        'dateTime': dateTime,
        'postID': postID,
        'userID': user.userID,
      };

  Comment.fromJson(String commentID, User user, Map<String, dynamic>? json)
      : this(
          commentID: commentID,
          content: json?['content'],
          dateTime: json?['dateTime'],
          postID: json?['postID'],
          user: user,
        );

  static Stream<List<Comment>> getCommentList(String postID) {
    ForumServiceFirebase forumServiceFirebase = ForumServiceFirebase();

    return forumServiceFirebase.getCommentList(postID);
  }

  Future comment() async {
    ForumServiceFirebase forumServiceFirebase = ForumServiceFirebase();

    await forumServiceFirebase.createComment(this);
  }
}
