import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/components/chats/Action/Expense/users_list.dart';
import 'package:udhaari/components/chats/settings/tags.dart';
import 'package:udhaari/components/chats/settings/update_group_name.dart';
import 'package:udhaari/components/chats/settings/users.dart';
import 'package:udhaari/store/chats/chat.dart';

class Settings extends HookConsumerWidget {
  const Settings({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chat = ref.watch(chatProvider.notifier);

    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: [
          UpdateGroupName(),
          TagsUpdate(),
          ListTile(
            title: Text("Copy Group Code"),
            subtitle: Text("${_chat.state.currentChat?.joinCode}"),
            trailing: Icon(Icons.copy),
            onTap: () {
              Clipboard.setData(
                ClipboardData(text: _chat.state.currentChat?.joinCode),
              );
            },
          ),
          Divider(),
          SettingsUser(
            role: Roles.admin,
          ),
          SettingsUser(
            role: Roles.member,
          ),
          Divider(),
          SettingsUser(role: Roles.requester)
        ],
      ),
    );
  }
}
