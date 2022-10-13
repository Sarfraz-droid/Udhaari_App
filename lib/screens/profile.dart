import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:udhaari/components/Layout/nav_appbar.dart';
import 'package:udhaari/components/navbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udhaari/store/auth/cubit/auth_cubit.dart';
import 'package:udhaari/store/counter/counter_cubit.dart';

class Profile extends HookWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final _authState = context.read<AuthCubit>();

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
        child: Column(
          children: [
            BlocBuilder<AuthCubit, AuthInitial>(
              builder: (context, state) {
                final user = state.user_id;
                return Text(
                  'User ID: $user',
                  style: Theme.of(context).textTheme.bodyText1,
                );
              },
            ),
            TextButton(
                onPressed: () {
                  _authState.logout();
                },
                child: Text('Logout')),
          ],
        ),
      ),
    );
  }
}
