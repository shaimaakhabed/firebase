import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthHelper {
  AuthHelper._();
  static AuthHelper authHelper = AuthHelper._();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  register(String email, String password, BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: 50,
            width: 50,
            child: Center(child: CircularProgressIndicator()),
          );
        });
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user.sendEmailVerification();
      Navigator.pop(context);
      print(userCredential.user.uid);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  login(String email, String password, BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
                height: 50,
                width: 50,
                child: Center(child: CircularProgressIndicator())),
          );
        });
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      print(userCredential.user.emailVerified);
      Navigator.pop(context);
      print(userCredential.user.uid);
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future logout() async {
    await firebaseAuth.signOut();
  }

  bool checkUser() {
    if (firebaseAuth.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }
  forgetPassword(String email)async{
    firebaseAuth.sendPasswordResetEmail(email: email);
  }
}