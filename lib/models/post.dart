import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/models/user.dart';
import 'package:jomsports/services/forum_service_firebase.dart';
import 'package:jomsports/services/storage_service_firebase.dart';
import 'package:jomsports/shared/constant/storage_destination.dart';

class Post {
  String postID;
  String title;
  String content;
  String dateTime;
  User user;
  SportsActivity? sportsActivity;
  List<String> postImages = [];
  int commentNo = 0;

  Post(
      {required this.postID,
      required this.title,
      required this.content,
      required this.dateTime,
      required this.user,
      this.sportsActivity});

  Map<String, dynamic> toJson() {
    if (sportsActivity != null) {
      return {
        'title': title,
        'content': content,
        'dateTime': dateTime,
        'userID': user.userID,
        'saID': sportsActivity!.saID,
      };
    } else {
      return {
        'title': title,
        'content': content,
        'dateTime': dateTime,
        'userID': user.userID
      };
    }
  }

  Post.fromJson(
      {required String postID,
      required User user,
      required Map<String, dynamic>? json,
      SportsActivity? sportsActivity})
      : this(
          postID: postID,
          title: json?['title'],
          content: json?['content'],
          dateTime: json?['dateTime'],
          sportsActivity: sportsActivity,
          user: user,
        );

  static Stream<List<Post>> getPostList() {
    ForumServiceFirebase forumServiceFirebase = ForumServiceFirebase();

    return forumServiceFirebase.getPostList();
  }

  static Stream<List<Post>> getPostListByUseerID(String userID) {
    ForumServiceFirebase forumServiceFirebase = ForumServiceFirebase();

    return forumServiceFirebase.getPostListByUserID(userID);
  }

  Future addPost(List<XFile> postImagesXFile) async {
    ForumServiceFirebase forumServiceFirebase = ForumServiceFirebase();
    postID = await forumServiceFirebase.createPost(this);

    //images
    if (postImagesXFile.isNotEmpty) {
      List<File> fileList = [];
      for (var xFile in postImagesXFile) {
        File image = File(xFile.path);
        fileList.add(image);
      }
      StorageServiceFirebase storageServiceFirebase = StorageServiceFirebase();
      await storageServiceFirebase.uploadMultipleFiles(
          StorageDestination.postPic, postID, fileList);
    }
  }

  Future getPostImages() async {
    StorageServiceFirebase storageServiceFirebase = StorageServiceFirebase();
    postImages = await storageServiceFirebase.getMultipleImages(
        StorageDestination.postPic, postID);
    return postImages;
  }

  Future getCommentNo() async {
    ForumServiceFirebase forumServiceFirebase = ForumServiceFirebase();
    commentNo = await forumServiceFirebase.getCommentNo(postID);
    return commentNo;
  }

  Future editPost() async {
    ForumServiceFirebase forumServiceFirebase = ForumServiceFirebase();
    return await forumServiceFirebase.editPost(this);
  }

  static Future getPost(String postID) async {
    ForumServiceFirebase forumServiceFirebase = ForumServiceFirebase();
    return await forumServiceFirebase.readPost(postID);
  }

  Future deletePost() async {
    ForumServiceFirebase forumServiceFirebase = ForumServiceFirebase();
    await forumServiceFirebase.deletePost(postID);

    await forumServiceFirebase.deleteCommentByPostID(postID);

    StorageServiceFirebase storageServiceFirebase = StorageServiceFirebase();
    await storageServiceFirebase.deleteMultipleFiles(StorageDestination.postPic, postID);
  }
}
