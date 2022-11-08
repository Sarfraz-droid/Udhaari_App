import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/components/chats/settings/tags/tags_container.dart';
import 'package:udhaari/store/chats/chat.dart';

class TagsUpdate extends HookConsumerWidget {
  const TagsUpdate({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chat = ref.watch(chatProvider.notifier);
    return ValueListenableBuilder(
        valueListenable: Hive.box('chats').listenable(keys: ['settings']),
        builder: ((context, value, child) {
          return ListTile(
            leading: Icon(Icons.label),
            title: Text('Update/Edit Tags'),
            subtitle: Text('Add or remove tags'),
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: ((context) {
                    return TagsContainer();
                  }));
            },
          );
        }));
  }
}
