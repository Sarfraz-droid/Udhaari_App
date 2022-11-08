import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/friends_list.dart';
import 'package:udhaari/components/Layout/nav_appbar.dart';
import 'package:udhaari/components/UI/Cards/user_card.dart';
import 'package:udhaari/components/add_group/index.dart';
import 'package:udhaari/components/navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/services/friends.dart';
import 'package:udhaari/services/users.dart';
import 'package:udhaari/store/users/users.dart';

class AddGroup extends HookConsumerWidget {
  const AddGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _users = ref.watch(usersProvider.notifier);

    Future<List<FriendsList?>> _onLoad() async {
      List<FriendsList?> users = await FriendsService().getFriends();
      return users;
    }

    return FutureBuilder(
      future: _onLoad(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AddGroupComp(
            users: snapshot.data,
          );
        }
        return Navbar(
          title: "Add Expense",
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
