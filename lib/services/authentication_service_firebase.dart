import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationServiceFirebase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseAuth get _auth => _firebaseAuth;

  Future signIn({required String email, required String password}) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = credential.user;

      if (user == null) {
        return;
      } else {
        return user;
      }
    } on FirebaseAuthException catch (e) {
      String message = e.code;

      if (e.code == 'wrong-password') {
        message= 'Incorrect email or password. Please try again.';
      } else if (e.code == 'user-not-found') {
        message = 'Incorrect email or password. Please try again.';
      }
      
      Get.replace(message,tag: 'message');
    }
  }
}
