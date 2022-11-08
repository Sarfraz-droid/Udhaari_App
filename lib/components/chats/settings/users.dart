import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/components/chats/settings/userModal.dart';
import 'package:udhaari/store/chats/chat.dart';

class SettingsUser extends HookConsumerWidget {
  final Roles role;
  SettingsUser({super.key, required this.role});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chat = ref.watch(chatProvider.notifier);
    final _users = useState<List<ProfileModel>>([]);
    final _currentUserRole = useState<Roles?>(null);

    useEffect(() {
      List<ChatRoles> chatRoles = _chat.state.currentChat!.roles!
          .where((element) => element.roles == role)
          .toList();

      _currentUserRole.value = _chat.state.currentChat!.roles!
          .firstWhere((element) =>
              element.uid == FirebaseAuth.instance.currentUser!.uid)
          .roles;

      List<ProfileModel> users = [];

      for (var i = 0; i < chatRoles.length; i++) {
        users.add(_chat.state.currentChat!.users!
            .firstWhere((element) => element.uid == chatRoles[i].uid));
      }

      _users.value = users;
    }, []);

    return Column(
      children: [
        Text(role.name.toString().toUpperCase(),
            style: ThemeData.light().textTheme.subtitle2),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _users.value.length,
          itemBuilder: (context, index) {
            ProfileModel user = _users.value[index];
            return ListTile(
              title: Text('${user.name}'),
              subtitle: Text('${user.email}'),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: ((context) {
                      return UserModal(
                          user: user, role: role, buildContext: context);
                    }));
              },
            );
          },
        ),
      ],
    );
  }
}
