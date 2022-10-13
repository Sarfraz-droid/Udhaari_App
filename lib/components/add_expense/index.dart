import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:udhaari/classes/friends_list.dart';
import 'package:udhaari/components/Layout/nav_appbar.dart';
import 'package:udhaari/components/UI/Cards/user_card.dart';
import 'package:udhaari/components/navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/services/friends.dart';
import 'package:udhaari/services/users.dart';

class AddExpenseComp extends HookWidget {
  List<FriendsList?>? users = [];
  AddExpenseComp({super.key, this.users});

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    print(users?.length);

    Future<void> _onCreateExpense(FriendsList _user) async {
      String chatId = await FirebaseFriends().createChat(
        _user.uid?.uid ?? "",
      );

      if (!mounted) return;
      GoRouter.of(context).push('/chat/${chatId}');
    }

    return Navbar(
      title: 'Add Expense',
      appBar: NavAppBar(
        title: 'Add Expense',
        showBackButton: true,
        onSearchChange: (value) {
          print(value);
        },
      ),
      showBottomNav: false,
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          return;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Actions',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  UserCard(
                    icon: Icons.person_add,
                    name: 'New Friend',
                    showDescription: false,
                    onTap: () {
                      GoRouter.of(context).push('/add_friends');
                    },
                  ),
                  const UserCard(
                    icon: Icons.group_add,
                    name: 'New Group',
                    showDescription: false,
                  ),
                ],
              ),
              const Divider(
                color: Colors.black12,
                height: 15,
                thickness: 1,
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Add Expense',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: users?.length ?? 0,
                  itemBuilder: (context, index) {
                    FriendsList _user = users![index] as FriendsList;
                    return UserCard(
                      name: _user.uid?.name ?? "Unknown",
                      description: _user.uid?.email,
                      icon: Icons.person,
                      onTap: () {
                        _onCreateExpense(_user);
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
