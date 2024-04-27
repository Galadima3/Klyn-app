// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:klyn/src/features/chat/data/chat_repository.dart';
import 'package:klyn/src/features/chat/presentation/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String recieverUserEmail;
  final String recieverUserID;
  const ChatScreen(
      {super.key,
      required this.recieverUserEmail,
      required this.recieverUserID});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatRepository chatService = ChatRepository();
  final _auth = FirebaseAuth.instance;
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await chatService.sendMessage(
          receiverID: widget.recieverUserID, message: _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recieverUserEmail),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),

          //Message Item

          //Message Input
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(hintText: 'Enter message'),
              )),
              IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(
                    Icons.send,
                    size: 40,
                  ))
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: chatService.getMessages(
          widget.recieverUserID, _auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        return ListView(
          children:
              snapshot.data!.docs.map((e) => _buildMessageItem(e)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderID'] == _auth.currentUser!.uid
        ? Alignment.centerRight
        : Alignment.centerLeft);

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: data['senderID'] == _auth.currentUser!.uid
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            SizedBox(
              height: 5,
            ),
            ChatBubble(message: data['message'])
          ],
        ),
      ),
    );
  }
}
