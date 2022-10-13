import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:udhaari/classes/chat.dart';
import 'package:udhaari/components/chats/chat_feed/ChatTypes/UI/chat_bubble.dart';
import 'package:udhaari/components/chats/index.dart';

class ExpenseType extends StatelessWidget {
  ChatMessage message;
  ExpenseType({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    print(message.expense?.total);

    final _settlement = message.expense?.settlement.firstWhere(
        (element) => element.uid == FirebaseAuth.instance.currentUser!.uid);

    final _expense = message.expense?.expenses.firstWhere(
        (element) => element.uid == FirebaseAuth.instance.currentUser!.uid);

    return Container(
      child: message.uid == FirebaseAuth.instance.currentUser!.uid
          ? ChatBubble(
              message: message,
              isSender: true,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${(_settlement?.amount ?? 0) < 0 ? "You get" : "You give"} ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    color: Colors.blue[400],
                    child: Text(
                      "₹ ${_settlement?.amount?.abs()}",
                      style: TextStyle(
                          color: (_settlement?.amount ?? 0) > 0
                              ? Colors.red[100]
                              : Colors.green[100],
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text("For",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Text('"${message.expense?.message ?? "No Message"}"',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    color: Colors.blue[400],
                    child: Row(
                      children: const [
                        Text(
                          "Created by You",
                          style: TextStyle(color: Colors.white),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.white,
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          : ChatBubble(
              message: message,
              isSender: false,
              child: Text(message.message ?? "Unkonwn"),
            ),
    );
  }
}
