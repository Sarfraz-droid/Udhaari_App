import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:udhaari/components/chats/chat_feed/index.dart';

class ChatFeedContainer extends StatelessWidget {
  String id;
  ChatFeedContainer({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('chats_${id}_messages').listenable(),
      builder: (context, value, child) {
        print("ChatFeedContainer: ValueListenableBuilder called");
        return ChatFeed();
      },
    );
  }
}
