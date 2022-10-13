import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:udhaari/app.dart';
import 'package:udhaari/store/auth/cubit/auth_cubit.dart';
import 'package:udhaari/store/chats/cubit/chat_cubit.dart';
import 'package:udhaari/store/counter/counter_cubit.dart';
import 'package:udhaari/store/users/cubit/users_cubit.dart';
import 'firebase_options.dart';

// Screens
import 'routes.dart';

String host = "localhost";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.useAuthEmulator(host, 9099);
  final firestore = FirebaseFirestore.instance;
  firestore.settings =
      const Settings(persistenceEnabled: false, sslEnabled: false);
  firestore.useFirestoreEmulator("localhost", 8080);
  FirebaseDatabase.instance.useDatabaseEmulator(host, 9000);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<CounterCubit>(
        create: (context) => CounterCubit(),
      ),
      BlocProvider<AuthCubit>(
        create: (_) => AuthCubit(),
      ),
      BlocProvider<UsersCubit>(
        create: (_) => UsersCubit(),
      ),
      BlocProvider<ChatCubit>(
        create: (context) => ChatCubit(),
      )
    ], child: const App());
  }
}
