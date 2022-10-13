import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:udhaari/classes/chat.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/components/chats/chat_feed/ChatTypes/index.dart';
import 'package:udhaari/services/chats.dart';
import 'package:udhaari/store/chats/cubit/chat_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatFeed extends HookWidget {
  ChatFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final _chats = context.watch<ChatCubit>();
    final _chatisloading = useState(true);
    FirebaseChat chatService = FirebaseChat(uid: _chats.state.currentChat!.id);

    Future<void> _onLoad() async {
      List<ChatMessage> messages =
          await chatService.getChatMessages(chat: _chats.state.currentChat!);
      _chats.updateCurrentChatMessages(messages);
      _chatisloading.value = false;
    }

    FirebaseFirestore.instance
        .collection("chats")
        .doc(_chats.state.currentChat!.id)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((event) async {
      print("ChatFeed: ${event.docs}");
      List<ChatMessage> messages = event.docs
          .map((e) => ChatMessage.fromJSON(e.data()))
          .toList()
          .reversed
          .toList();

      for (int i = 0; i < messages.length; i++) {
        await messages[i].loadExpense();
      }
      _chats.updateCurrentChatMessages(messages);
    });

    return FutureBuilder(
      future: _onLoad(),
      builder: (context, snapshot) {
        if (_chatisloading.value) {
          return Container(
            child: const Text('Loading...'),
          );
        }
        return Container(
          child: ListView.builder(
            itemCount: _chats.state.currentChatMessages!.length,
            itemBuilder: (context, index) {
              ChatMessage message = _chats.state.currentChatMessages![index];
              return Container(
                child: chatTypes[message.type]!(message: message),
              );
            },
          ),
        );
      },
    );
  }
}
