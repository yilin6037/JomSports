import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jomsports/models/comment.dart';
import 'package:jomsports/models/post.dart';
import 'package:jomsports/models/sports_activity.dart';
import 'package:jomsports/models/user.dart';
import 'package:jomsports/shared/constant/firestore.dart';

class ForumServiceFirebase {
  final firestoreInstance = FirebaseFirestore.instance;

  Stream<List<Post>> getPostList() {
    return firestoreInstance
        .collection(FirestoreCollectionConstant.post)
        .orderBy('dateTime')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Post> postList = [];
      for (var doc in snapshot.docs) {
        User user = await User.getUser(doc.data()['userID']);
        user.getProfilePicUrl();
        SportsActivity? sportsActivity;
        if (doc.data().containsKey('saID')) {
          sportsActivity =
              await SportsActivity.getSportsActivity(doc.data()['saID']);
        }
        Post post = Post.fromJson(
            postID: doc.id,
            user: user,
            json: doc.data(),
            sportsActivity: sportsActivity);
        await post.getPostImages();
        await post.getCommentNo();
        postList.add(post);
      }
      return postList;
    });
  }

  Stream<List<Post>> getPostListByUserID(String userID) {
    return firestoreInstance
        .collection(FirestoreCollectionConstant.post)
        .where('userID', isEqualTo: userID)
        .orderBy('dateTime')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Post> postList = [];
      for (var doc in snapshot.docs) {
        User user = await User.getUser(doc.data()['userID']);
        user.getProfilePicUrl();
        SportsActivity? sportsActivity;
        if (doc.data().containsKey('saID')) {
          sportsActivity =
              await SportsActivity.getSportsActivity(doc.data()['saID']);
        }
        Post post = Post.fromJson(
            postID: doc.id,
            user: user,
            json: doc.data(),
            sportsActivity: sportsActivity);
        await post.getPostImages();
        await post.getCommentNo();
        postList.add(post);
      }
      return postList;
    });
  }

  Future<int> getCommentNo(String postID) async {
    final docs = await firestoreInstance
        .collection(FirestoreCollectionConstant.comment)
        .where('postID', isEqualTo: postID)
        .get();
    return docs.docs.length;
  }

  Future<String> createPost(Post post) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.post)
        .add(post.toJson())
        .then((value) => value.id);
  }

  Future editPost(Post post) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.post)
        .doc(post.postID)
        .update(post.toJson());
  }

  Future<Post?> readPost(String postID) async {
    final snapshot = await firestoreInstance
        .collection(FirestoreCollectionConstant.post)
        .doc(postID)
        .get();
    if (snapshot.exists) {
      User user = await User.getUser(snapshot.data()!['userID']);
      user.getProfilePicUrl();
      SportsActivity? sportsActivity;
      if (snapshot.data()!.containsKey('saID')) {
        sportsActivity =
            await SportsActivity.getSportsActivity(snapshot.data()!['saID']);
      }
      Post post = Post.fromJson(
          postID: snapshot.id,
          user: user,
          json: snapshot.data(),
          sportsActivity: sportsActivity);
      await post.getPostImages();
      await post.getCommentNo();
      return post;
    } else {
      return null;
    }
  }

  Future deletePost(String postID) async {
    await firestoreInstance
        .collection(FirestoreCollectionConstant.post)
        .doc(postID)
        .delete();
  }

  Stream<List<Comment>> getCommentList(String postID) {
    return firestoreInstance
        .collection(FirestoreCollectionConstant.comment)
        .where('postID', isEqualTo: postID)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Comment> commentList = [];
      for (var doc in snapshot.docs) {
        User user = await User.getUser(doc.data()['userID']);
        commentList.add(Comment.fromJson(doc.id, user, doc.data()));
      }
      return commentList;
    });
  }

  Future createComment(Comment comment) async {
    return await firestoreInstance
        .collection(FirestoreCollectionConstant.comment)
        .add(comment.toJson());
  }

  Future deleteCommentByPostID(String postID) async {
    final snapshot = await firestoreInstance
        .collection(FirestoreCollectionConstant.comment)
        .where('postID', isEqualTo: postID)
        .get();

    for (var doc in snapshot.docs) {
      await firestoreInstance
          .collection(FirestoreCollectionConstant.comment)
          .doc(doc.id)
          .delete();
    }
  }
}
