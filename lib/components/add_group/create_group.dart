import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:udhaari/store/chats/chat.dart';

class AddGroupInfo extends HookConsumerWidget {
  Function onContinue;
  AddGroupInfo({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _groupText = useState('');
    final _groupName = useState(TextEditingController());
    final _groupDescription = useState(TextEditingController());

    final chatStore = ref.watch(chatProvider.notifier);

    useEffect(() {
      print('useEffect ${_groupName.value.text}');
    }, [_groupName.value.text]);

    void _createGroup() {
      print('create group');

      if (_groupName.value.text.length <= 2) {
        showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                title:
                    const Text('Group Name should have atleast 3 characters'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'))
                ],
              );
            }));

        return;
      }

      chatStore.createGroup(
          name: _groupName.value.text,
          description: _groupDescription.value.text);

      onContinue();
      GoRouter.of(context).go('/');
    }

    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Add Group Info",
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            SizedBox(height: 20.0),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 40.0,
                  child: Text(
                    _groupText.value.length > 2
                        ? _groupText.value.substring(0, 2).toUpperCase()
                        : "UA",
                    style: const TextStyle(fontSize: 30.0),
                  ),
                )),
            TextField(
              controller: _groupName.value,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Group Name',
              ),
              onChanged: ((value) {
                print('onChanged $value');
                _groupText.value = value;
              }),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _groupDescription.value,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Group Description',
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _createGroup();
                },
                style: ButtonStyle(elevation: MaterialStateProperty.all(0.0)),
                child: Text('Create Group'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
