import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:udhaari/classes/chat.dart';
import 'package:udhaari/components/Layout/nav_appbar.dart';
import 'package:udhaari/components/chats/index.dart';
import 'package:udhaari/components/navbar.dart';
import 'package:udhaari/services/chats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udhaari/store/chats/cubit/chat_cubit.dart';
import 'package:dartx/dartx.dart';

class ChatPage extends HookWidget {
  final String id;
  const ChatPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final _chats = context.read<ChatCubit>();

    Future<ChatModel> _onLoad() async {
      // ChatModel res = await FirebaseChat(uid: id).getChatData();
      ChatModel res = await _chats.loadChatData(id);
      _chats.updateCurrentChat(res);
      return res;
    }

    FirebaseFirestore.instance
        .collection("chats")
        .doc(id)
        .snapshots()
        .listen(((event) {
      print("ChatPage: ${event.data()}");
      _chats.updateCurrentChat(ChatModel.fromJSON(event.data()!));
    }));

    return FutureBuilder(
      future: _onLoad(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ChatComponent(
            chat: snapshot.data,
          );
        }
        return Navbar(
          title: "Chat",
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
