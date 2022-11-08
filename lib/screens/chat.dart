import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/components/Layout/nav_appbar.dart';
import 'package:udhaari/components/chats/index.dart';
import 'package:udhaari/components/navbar.dart';
import 'package:udhaari/services/chats.dart';
import 'package:dartx/dartx.dart';
import 'package:udhaari/store/chats/chat.dart';
import 'package:udhaari/store/dashboard/dashboard.dart';
import 'package:udhaari/store/settings/settings.dart';

class ChatPage extends HookConsumerWidget {
  final String id;
  const ChatPage({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chats = ref.watch(chatProvider.notifier);
    final _dashboard = ref.watch(dashboardProvider.notifier);
    final _settings = ref.watch(settingsProvider.notifier);

    Future<ChatModel> _onLoad() async {
      ChatModel res = ChatService(chatId: id).loadChatModel();
      await res.validateGroupName();
      await res.loadUsers();
      print(res.groupName);

      _chats.updateCurrentChat(res);
      await Hive.openBox('chats_${_chats.state.currentChat!.id}_messages');
      await Hive.openBox('chats_${_chats.state.currentChat!.id}_expenses');

      // await Hive.deleteBoxFromDisk(
      //     'chats_${_chats.state.currentChat!.id}_transactions');
      await Hive.openBox('chats_${_chats.state.currentChat!.id}_transactions');
      await Hive.openBox('chats_${_chats.state.currentChat!.id}');

      _settings.loadSettings();
      _dashboard.loadDashboard();

      

      return res;
    }

    return FutureBuilder(
      future: _onLoad(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ChatComponent(chat: snapshot.data);
        }
        return Navbar(
          title: "Chat",
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
