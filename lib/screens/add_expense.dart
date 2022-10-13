import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:udhaari/classes/friends_list.dart';
import 'package:udhaari/components/Layout/nav_appbar.dart';
import 'package:udhaari/components/UI/Cards/user_card.dart';
import 'package:udhaari/components/add_expense/index.dart';
import 'package:udhaari/components/navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/services/friends.dart';
import 'package:udhaari/services/users.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udhaari/store/users/cubit/users_cubit.dart';

class AddExpense extends HookWidget {
  const AddExpense({super.key});

  @override
  Widget build(BuildContext context) {
    final _users = context.watch<UsersCubit>();

    Future<List<FriendsList?>> _onLoad() async {
      List<FriendsList?> users = await FirebaseFriends().getFriends();
      return users;
    }

    return FutureBuilder(
      future: _onLoad(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AddExpenseComp(
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
