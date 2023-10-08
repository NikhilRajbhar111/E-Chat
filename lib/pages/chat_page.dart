import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/components/chat_bubble.dart';
import 'package:my_app/components/my_text_field.dart';
import 'package:my_app/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String reciverUserEmail;
  final String reciverUserId;
  const ChatPage({
    super.key,
    required this.reciverUserEmail,
    required this.reciverUserId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    //only send message if the is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.reciverUserId, _messageController.text);
      //clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text(widget.reciverUserEmail), 
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [

            Expanded(
              child: _buildMessageList(),
            ),

            //user input
            _buildMessageInput(),
            const SizedBox(height: 15,),
          ],
        ));
  }

  //build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        widget.reciverUserId,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build message item
Widget _buildMessageItem(DocumentSnapshot document) {
  Map<String, dynamic> data = document.data() as Map<String, dynamic>;

  // place the message to the right if the sender is the current user, else to the left
  var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
      ? Alignment.centerRight
      : Alignment.centerLeft;

  return Container(
    alignment: alignment,
    child: Column(
      crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ? MainAxisAlignment.end: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(data['senderEmail']),
        const SizedBox(height: 5),
        ChatBubble(message: data['message'], backgroundColor: Colors.black, textColor: Colors.white,),
      ],
    ),
  );
}

  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
        Expanded(
          child: MyTextField(
              controller: _messageController,
              hintText: 'Enter message',
              obscureText: false),
        ),
        //icon button
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_upward,
              size: 40,
            )),
      ],
      ),
    );
  }
}