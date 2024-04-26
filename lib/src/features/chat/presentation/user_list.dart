import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _firestore.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data();
              // Add your UI widgets here based on the data
              if (_auth.currentUser!.email != data['email']) {
                return ListTile(
                  title: Text(data['email']),
                  // Add more widgets as needed
                );
              } else {
               return Container(); 
              }
            }).toList(),
          );
        },
      ),
    );
  }
}
