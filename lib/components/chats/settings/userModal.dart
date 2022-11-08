import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/services/chats.dart';
import 'package:udhaari/store/chats/chat.dart';

class UserModal extends HookConsumerWidget {
  final ProfileModel user;
  final Roles role;
  final BuildContext buildContext;
  UserModal(
      {super.key,
      required this.user,
      required this.role,
      required this.buildContext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chat = ref.watch(chatProvider.notifier);
    final _currentUserRole = useState<Roles?>(null);

    useEffect(() {
      _currentUserRole.value = _chat.state.currentChat!.roles!
          .firstWhere((element) =>
              element.uid == FirebaseAuth.instance.currentUser!.uid)
          .roles;
    }, []);

    return Container(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                child: Text('${user.name?.substring(0, 2).toUpperCase()}'),
                radius: 30.0,
              ),
              SizedBox(height: 10),
              Text('${user.name}',
                  style: Theme.of(context).textTheme.headline6),
              SizedBox(height: 10),
              Text('${role.name.toUpperCase()}',
                  style: Theme.of(context).textTheme.subtitle1),
              Row(
                children: [
                  TextButton(onPressed: () {}, child: Text('Cancel')),
                  Spacer(),
                  if (_currentUserRole.value != null &&
                      _currentUserRole.value! == Roles.admin &&
                      role == Roles.requester)
                    ElevatedButton(
                        onPressed: () {
                          ChatService(chatId: _chat.state.currentChat!.id)
                              .updateUserRole(user.uid!, Roles.member);

                          Navigator.pop(buildContext);
                        },
                        child: Text('Accept Request')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
