import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:udhaari/routes.dart';
import 'package:udhaari/store/auth/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final _authState = context.read<AuthCubit>();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      _authState.update(user);
      print('user : $user');
      if (user == null) {
        router.push('/auth/login');
      } else {
        // router.push('/');
      }
    });

    return MaterialApp.router(
      routerConfig: router,
      title: 'Udhaari',
    );
  }
}
