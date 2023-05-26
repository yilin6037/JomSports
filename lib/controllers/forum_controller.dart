import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jomsports/models/comment.dart';
import 'package:jomsports/models/post.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/models/user.dart';
import 'package:jomsports/shared/constant/role.dart';
import 'package:jomsports/shared/dialog/dialog.dart';
import 'package:jomsports/views/forum/forum/view_post_page.dart';

import 'user_controller.dart';

class ForumController extends GetxController {
  final UserController userController = Get.find(tag: 'userController');

  int navIndex = 0;
  void initIndex() {
    switch (userController.currentUser.userType) {
      case Role.admin:
        navIndex = 2;
        break;
      case Role.sportsLover:
        navIndex = 3;
        break;
      case Role.sportsRelatedBusiness:
        navIndex = 2;
        break;
      default:
        navIndex = 0;
        break;
    }
  }

  //view wall
  Rx<dynamic> selectedUser = Rx(null);
  RxString selectedUserID = RxString('');

  Future initWall(String userID) async {
    selectedUserID.value = userID;
    if (userID == '') {
      selectedUser.value = null;
    } else if (userID == userController.currentUser.userID) {
      selectedUser.value = userController.currentUser;
    } else {
      selectedUser.value = await User.getUser(userID);
      await selectedUser.value.getProfilePicUrl();
    }
  }

  Stream<List<Post>> getPostList(String? userID) {
    if (userID != null && userID.isNotEmpty) {
      return Post.getPostListByUseerID(userID);
    } else {
      return Post.getPostList();
    }
  }

  //create and edit post
  GlobalKey<FormState> postFormKey = GlobalKey<FormState>();
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController contentTextEditingController = TextEditingController();
  List<XFile> postPictures = [];
  Rx<SportsActivity?> attachedSportsActivity = Rx<SportsActivity?>(null);

  void onSelectPostImages(List<XFile> imagesSelected) {
    postPictures = imagesSelected.map((e) => XFile(e.path)).toList();
  }

  void onSelectSportsActivity(SportsActivity sportsActivity) {
    attachedSportsActivity.value = sportsActivity;
  }

  Future addPost() async {
    Post post = Post(
        postID: '',
        title: titleTextEditingController.text,
        content: contentTextEditingController.text,
        dateTime: DateTime.now().toString(),
        user: userController.currentUser);

    if (attachedSportsActivity.value != null) {
      post.sportsActivity = attachedSportsActivity.value;
    }

    await post.addPost(postPictures);

    initPost(post);
    SharedDialog.directDialog(
        'Success', 'Post is created successfully!', ViewPostPage());
    cleanPostForm();
  }

  void cleanPostForm() {
    postFormKey = GlobalKey<FormState>();
    titleTextEditingController = TextEditingController();
    contentTextEditingController = TextEditingController();
    postPictures = [];
    attachedSportsActivity = Rx<SportsActivity?>(null);
  }

  void initEditPostForm(Post post) {
    postFormKey = GlobalKey<FormState>();
    titleTextEditingController = TextEditingController(text: post.title);
    contentTextEditingController = TextEditingController(text: post.content);
    selectedPost = post;
  }

  Future editPost() async {
    Post post = Post(
        postID: selectedPost!.postID,
        title: titleTextEditingController.text,
        content: contentTextEditingController.text,
        dateTime: selectedPost!.dateTime,
        user: selectedPost!.user);

    await post.editPost();
    SharedDialog.directDialog(
        'Success', 'Post is edited successfully', ViewPostPage());
    cleanPostForm();
  }

  //view post
  Post? selectedPost;
  void initPost(Post post) {
    selectedPost = post;
    initCommentForm();
  }

  Future<Post> getPost() async {
    if (selectedPost == null) {
      SharedDialog.errorDialog();
      Get.back();
    }
    Post? post = await Post.getPost(selectedPost!.postID);
    if (post != null) {
      selectedPost = post;
    }
    return selectedPost!;
  }

  //delete
  Future deletePost() async {
    if (selectedPost != null) {
      await selectedPost!.deletePost();
    } else {
      SharedDialog.errorDialog();
    }
  }

  //comment
  Stream<List<Comment>> getCommentList() {
    return Comment.getCommentList(selectedPost!.postID);
  }

  GlobalKey<FormState> commentFormKey = GlobalKey<FormState>();
  TextEditingController commentTextController = TextEditingController();

  Future onComment() async {
    Comment comment = Comment(
        commentID: '',
        content: commentTextController.text,
        dateTime: DateTime.now().toString(),
        postID: selectedPost!.postID,
        user: userController.currentUser);

    await comment.comment();
  }

  void cleanComment() {
    commentTextController.text = '';
  }

  void initCommentForm() {
    commentFormKey = GlobalKey<FormState>();
    commentTextController = TextEditingController();
  }
}
