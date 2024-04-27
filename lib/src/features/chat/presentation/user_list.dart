import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:klyn/src/features/chat/data/chat_repository.dart';
import 'package:klyn/src/features/chat/presentation/chat_page.dart';

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final chatrepo = ChatRepository();
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: chatrepo.userList,
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
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return ChatScreen(
                          recieverUserEmail: data['email'],
                          recieverUserID: data['uid']);
                    },
                  )),
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
