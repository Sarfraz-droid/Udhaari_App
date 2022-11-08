import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:udhaari/app.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/services/cloud_messaging/reciever.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Screens
import 'routes.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("Message: ${message.data}");
  await Firebase.initializeApp();
  final user = FirebaseAuth.instance.currentUser;

  FirebaseFirestore.instance.collection(user!.uid).add(message.data);
}

bool useEmulator = false;

String host = "localhost";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Hive setup

  await Hive.initFlutter();
  // await Hive.deleteBoxFromDisk('chats');
  await Hive.openBox('users');
  await Hive.openBox('users_list');
  await Hive.openBox('chats');
  await Hive.openBox('new_chats');

// Initialize Firebase
  var app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);

  // Emulator Setup
  if (useEmulator) {
    FirebaseAuth.instance.useAuthEmulator(host, 9099);
    final firestore = FirebaseFirestore.instance;
    firestore.useFirestoreEmulator("localhost", 8080);
    FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  }
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  runApp(MyApp(
    initialLink: initialLink,
  ));
}

class MyApp extends StatelessWidget {
  PendingDynamicLinkData? initialLink;
  MyApp({super.key, required this.initialLink});

  @override
  Widget build(BuildContext context) {
    FirebaseNotificationsReciever notifications =
        FirebaseNotificationsReciever();
    final user = FirebaseAuth.instance.currentUser;
    Future<int> _requestPermission() async {
      print('Link ${initialLink}');
      if (Platform.isAndroid) {
        Permission.contacts.request();
      }
      if (user == null) return 1;
      final newChats =
          await FirebaseFirestore.instance.collection(user.uid).get();

      print('New Chats: ${newChats.docs.length}');

      for (int i = 0; i < newChats.docs.length; i++) {
        notifications.dataHandler(newChats.docs[i].data());
        await FirebaseFirestore.instance
            .collection(user.uid)
            .doc(newChats.docs[i].id)
            .delete();
      }

      return 1;
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      FirebaseNotificationsReciever notifications =
          FirebaseNotificationsReciever();
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      notifications.dataHandler(message.data);

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    if (user != null) {
      FirebaseFirestore.instance
          .collection(user!.uid)
          .snapshots()
          .listen((event) {
        for (int i = 0; i < event.docs.length; i++) {
          notifications.dataHandler(event.docs[i].data());
          FirebaseFirestore.instance
              .collection(user.uid)
              .doc(event.docs[i].id)
              .delete();
        }
      });
    }
    return FutureBuilder(
        future: _requestPermission(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const ProviderScope(child: App());
          }
          return Container();
        });
  }

  @override
  void dispose() {
    Hive.close();
  }
}
