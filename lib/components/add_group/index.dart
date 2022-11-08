import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:udhaari/classes/friends_list.dart';
import 'package:udhaari/components/Layout/nav_appbar.dart';
import 'package:udhaari/components/UI/Cards/user_card.dart';
import 'package:udhaari/components/add_group/group_home.dart';
import 'package:udhaari/components/add_group/create_group.dart';
import 'package:udhaari/components/add_group/search_group.dart';
import 'package:udhaari/components/navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/services/friends.dart';
import 'package:udhaari/services/users.dart';

// ignore: must_be_immutable
class AddGroupComp extends HookWidget {
  List<FriendsList?>? users = [];
  AddGroupComp({super.key, this.users});

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    print(users?.length);
    final _currentStep = useState(0);
    final _widgets = useState([
      AddGroupHome(
        onChange: (value) {
          print(value);
          _currentStep.value = value;
        },
      ),
      AddGroupInfo(
        onContinue: () {
          _currentStep.value = 1;
        },
      ),
      JoinGroup()
    ]);

    return Navbar(
      title: 'Create Group',
      appBar: NavAppBar(
        title: 'Create Group',
        showBackButton: true,
        onSearchChange: (value) {},
      ),
      showBottomNav: false,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _widgets.value[_currentStep.value]),
    );
  }
}
