import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUser extends StatelessWidget {
  final String fullName;
  final String city;
  final int age;
 final String email;

  String password;


  AddUser(this.email,
      this.password,this.fullName, this.city, this.age);

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'full_name': fullName, // John Doe
            'city': city, // Stokes and Sons
            'age': age // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return FlatButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }
}



