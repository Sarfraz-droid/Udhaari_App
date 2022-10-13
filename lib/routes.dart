import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:udhaari/screens/add_expense.dart';
import 'package:udhaari/screens/add_friend.dart';
import 'package:udhaari/screens/chat.dart';
import 'package:udhaari/screens/friends.dart';
import 'package:udhaari/screens/home.dart';
import 'package:udhaari/screens/auth.dart';
import 'package:udhaari/screens/profile.dart';

class Routes {
  String path;
  Function page;
  List<Routes> children;

  Routes({required this.path, required this.page, this.children = const []});
}

final List<Routes> routes = [
  Routes(path: '/', page: (context, state) => Home()),
  Routes(
      path: '/auth/login',
      page: (context, state) => const AuthPage(title: 'Login')),
  Routes(
      path: '/auth/register',
      page: (context, state) =>
          const AuthPage(title: 'Register', isLogin: false)),
  Routes(
    path: '/friends',
    page: (context, state) => const Friends(),
  ),
  Routes(
      path: '/chat/:id',
      page: (context, state) => ChatPage(
            id: state?.params['id']!,
          )),
  Routes(path: '/add_friends', page: (context, state) => const AddFriend()),
  Routes(
    path: '/add_expense',
    page: (context, state) => const AddExpense(),
  ),
  Routes(path: '/profile', page: (context, state) => const Profile()),
];

final GoRouter router = GoRouter(routes: <GoRoute>[
  for (var route in routes)
    GoRoute(
        path: route.path,
        builder: (context, state) => route.page(context, state),
        routes: <RouteBase>[
          for (var child in route.children)
            GoRoute(
              path: child.path,
              builder: (context, state) => route.page(context, state),
            )
        ])
]);
