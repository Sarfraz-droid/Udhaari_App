import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/classes/user.dart';
import 'package:udhaari/components/Layout/nav_appbar.dart';
import 'package:udhaari/components/chats/chat_feed/chat_feed_container.dart';
import 'package:udhaari/components/chats/dashboard/index.dart';
import 'package:udhaari/components/chats/settings/index.dart';
import 'package:udhaari/screens/add_action_container.dart';
import 'package:udhaari/components/chats/Action/Expense/addExpenseModal.dart';
import 'package:udhaari/components/chats/chat_feed/index.dart';
import 'package:udhaari/components/navbar.dart';
import 'package:udhaari/hooks/useAsyncEffect.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:udhaari/services/chats.dart';
import 'package:go_router/go_router.dart';

class ChatComponent extends HookWidget {
  ChatModel? chat;
  bool _keyboardVisible = false;
  ChatComponent({super.key, this.chat});

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return DefaultTabController(
      length: 3,
      child: Navbar(
        title: chat?.groupName ?? "Unknown",
        appBar: AppBar(
          title: Text(chat?.groupName ?? "Unknown"),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.chat),
              ),
              Tab(
                icon: Icon(Icons.balance),
              ),
              Tab(
                icon: Icon(Icons.settings),
              )
            ],
          ),
        ),
        floatingAction: FloatingActionButton(
          onPressed: () {
            GoRouter.of(context).push('/chat/${chat?.id}/add');
          },
          child: const Icon(Icons.add),
        ),
        showBottomNav: false,
        child: TabBarView(children: [
          ChatFeedContainer(id: chat!.id!),
          const Dashboard(),
          Settings()
        ]),
      ),
    );
  }
}
