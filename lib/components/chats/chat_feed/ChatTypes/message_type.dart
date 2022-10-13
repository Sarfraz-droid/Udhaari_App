import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:udhaari/classes/chat.dart';
import 'package:udhaari/components/chats/chat_feed/ChatTypes/UI/chat_bubble.dart';

class MessageType extends StatelessWidget {
  ChatMessage message;
  MessageType({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: message.uid == FirebaseAuth.instance.currentUser!.uid
          ? ChatBubble(
              message: message,
              isSender: true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(message.message!,
                    style: TextStyle(color: Colors.white)),
              ),
            )
          : ChatBubble(
              message: message,
              isSender: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(message.message!),
              ),
            ),
    );
  }
}
