import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/chat/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isSender;
  final Widget child;
  ChatBubble(
      {super.key,
      required this.message,
      required this.isSender,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (isSender)
            SizedBox(
              width: 50,
            ),
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  color: isSender ? Colors.blue : Colors.grey,
                  borderRadius: BorderRadius.only(
                    bottomLeft:
                        isSender ? Radius.circular(10) : Radius.circular(0),
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight:
                        isSender ? Radius.circular(0) : Radius.circular(10),
                  )),
              child: child,
            ),
          ),
          if (!isSender)
            SizedBox(
              width: 50,
            ),
        ],
      ),
    ));
  }
}
