import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:udhaari/store/auth/auth.dart';

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authState = ref.watch(authProvider.notifier);

    Future<void> updateToken() async {
      String? token = await FirebaseMessaging.instance.getToken();
      print("Token: $token");
      _authState.updateToken(token!);
    }
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _authState.update(user);
      print('user : $user');
      
      if (user == null) {
        router.push('/auth/login');
      } else {
        // router.push('/');
        updateToken();
      }
    });

    return MaterialApp.router(
      routerConfig: router,
      title: 'Udhaari',
    );
  }
}
