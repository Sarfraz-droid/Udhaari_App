import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/components/Layout/nav_appbar.dart';
import 'package:udhaari/components/navbar.dart';
import 'package:udhaari/store/auth/auth.dart';

class Profile extends HookConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authState = ref.watch(authProvider.notifier);

    return Navbar(
      title: 'Profile',
      appBar: NavAppBar(
        title: 'Profile',
        onSearchChange: (value) {
          print(value);
        },
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 35.0,
                child: Text('${_authState.state.user?.name?.substring(0, 2)}',
                    style:
                        const TextStyle(fontSize: 25.0, color: Colors.white)),
              ),
              const SizedBox(height: 10.0),
              Text(
                '${_authState.state.user?.name}',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 10.0),
              Text(
                'User ID: ${_authState.state.user_id}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Spacer(),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   child: ElevatedButton(
              //       onPressed: () {
              //         _authState.logout();
              //       },
              //       child: Text('Logout')),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
