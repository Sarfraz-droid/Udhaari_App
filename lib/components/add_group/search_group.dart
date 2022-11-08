import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/components/add_group/groupModal.dart';
import 'package:udhaari/services/chats.dart';

class JoinGroup extends HookConsumerWidget {
  const JoinGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _groupNameController = useState(TextEditingController());
    final _groups = useState<List<ChatModel>>([]);

    Future<void> searchGroup(String code) async {
      _groups.value = await ChatService().searchGroups(query: code);
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _groupNameController.value,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  searchGroup(_groupNameController.value.text);
                },
              ),
              hintText: 'Enter Group Code',
            ),
          ),
        ),
        Divider(),
        ListView.builder(
          itemCount: _groups.value.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${_groups.value[index].groupName}'),
              subtitle: Text('${_groups.value[index].members?.length} members'),
              onTap: () async {
                showModalBottomSheet(
                    context: context,
                    builder: ((context) {
                      return GroupModal(
                        group: _groups.value[index],
                        modalContext: context,
                      );
                    }));
              },
            );
          },
        )
      ],
    );
  }
}
