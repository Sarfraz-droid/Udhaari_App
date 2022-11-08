import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/services/chats.dart';

class GroupModal extends ConsumerWidget {
  final BuildContext modalContext;
  ChatModel group;
  GroupModal({super.key, required this.group, required this.modalContext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25.0,
            child: Text(group.groupName!.substring(0, 2).toUpperCase()),
          ),
          const SizedBox(height: 10.0),
          Text(
            '${group.groupName}',
            style: Theme.of(context).textTheme.headline6,
          ),
          Text('${group.members?.length} members'),
          const SizedBox(height: 20.0),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.of(modalContext).pop();
                  },
                  child: const Text('Cancel')),
              const Spacer(),
              if (group.members!
                      .contains(FirebaseAuth.instance.currentUser!.uid) ==
                  false)
                ElevatedButton(
                    onPressed: () {
                      ChatService().joinRequestGroup(chatModel: group);
                      Navigator.of(modalContext).pop();
                    },
                    child: Text('Send Join Request')),
              if (group.members!
                  .contains(FirebaseAuth.instance.currentUser!.uid))
                Text('Joined')
            ],
          )
        ],
      ),
    );
  }
}
