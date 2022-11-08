import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/store/chats/chat.dart';

class UpdateGroupName extends HookConsumerWidget {
  const UpdateGroupName({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chat = ref.watch(chatProvider.notifier);

    final _groupNameController = useState(TextEditingController());
    final _isEdit = useState(false);

    useEffect(() {
      _groupNameController.value.text = _chat.state.currentChat!.groupName!;
    }, []);

    return ListTile(
      title: _isEdit.value
          ? TextField(
              controller: _groupNameController.value,
              decoration: InputDecoration(
                hintText: 'Group Name',
              ))
          : Text('${_chat.state.currentChat!.groupName}'),
      subtitle: _isEdit.value
          ? null
          : Text('${_chat.state.currentChat!.members?.length} members'),
      trailing: Wrap(
        children: [
          if (_isEdit.value)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _chat.updateGroupName(_groupNameController.value.text);
                _isEdit.value = false;
              },
            ),
          // if (_chat.state.currentChat?.isGroup != null)
          //   IconButton(
          //     icon: Icon(_isEdit.value ? Icons.check : Icons.edit),
          //     onPressed: () {
          //       _isEdit.value = !_isEdit.value;
          //       if (!_isEdit.value) {
          //         _chat.updateGroupName(_groupNameController.value.text);
          //       }
          //     },
          //   ),
        ],
      ),
    );
  }
}
