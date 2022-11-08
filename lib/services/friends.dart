import 'dart:convert';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/chat/chat_list.dart';
import 'package:udhaari/classes/friends_list.dart';
import 'package:udhaari/classes/user_friends.dart';
import 'package:udhaari/services/hive/chat/dashboard.dart';
import 'package:udhaari/services/hive/chat/settings.dart';
import 'package:udhaari/services/users.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/classes/user.dart';
import 'package:udhaari/screens/profile.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FriendsService {
  final uuid = const Uuid();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseFunctions functions = FirebaseFunctions.instance;

  final chats = Hive.box('chats');

  Future<void> addFriend(String uid) async {
    print("Adding friend $uid");
    CollectionReference users = _firestore.collection('users');
    User? user = await UsersService().getCurrentUser();

    await users.doc(user?.uid).update({
      'friends': FieldValue.arrayUnion([
        {
          'uid': uid,
          'created_at': DateTime.now().millisecondsSinceEpoch,
        }
      ]),
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    });

    await users.doc(uid).update({
      'friends': FieldValue.arrayUnion([
        {
          'uid': user?.uid,
          'created_at': DateTime.now().millisecondsSinceEpoch,
        }
      ]),
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    });
    print("Friend added");
  }

  Future<List<FriendsList?>> getFriends() async {
    List<FriendsList?> friendsList = [];
    
    return friendsList;
  }

  Future<String> fbcreateChat(String friend) async {
    CollectionReference chats = _firestore.collection('chats');
    CollectionReference messages = _firestore.collection('messages');

    QuerySnapshot chat_query = await chats.where(
      'members',
      whereIn: [
        [friend, _auth.currentUser!.uid],
        [_auth.currentUser!.uid, friend]
      ],
    ).get();

    print('${chat_query.docs.length} Chats for both');

    if (chat_query.docs.isNotEmpty) {
      return chat_query.docs[0].id;
    }

    String chatId = uuid.v4();
    String messageId = uuid.v4();

    await chats.doc(chatId).set({
      'id': chatId,
      'members': [friend, _auth.currentUser!.uid],
      'isGroup': false,
      'created_at': DateTime.now().millisecondsSinceEpoch,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    });

    return chatId;
  }


}
