import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'package:udhaari/classes/chat.dart';
import 'package:udhaari/classes/friends_list.dart';
import 'package:udhaari/classes/user_friends.dart';
import 'package:udhaari/services/users.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/classes/user.dart';
import 'package:udhaari/screens/profile.dart';

class FirebaseFriends {
  final uuid = Uuid();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFriend(String uid) async {
    print("Adding friend $uid");
    CollectionReference users = _firestore.collection('users');
    User? user = await FirebaseUsers().getCurrentUser();

    // String chatId = uuid.v4();
    // await chats.doc(chatId).set({
    //   'id': chatId,
    //   'users': [user.uid, uid],
    //   'created_at': DateTime.now().millisecondsSinceEpoch,
    //   'updated_at': DateTime.now().millisecondsSinceEpoch,
    // });

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
    CollectionReference users = _firestore.collection('users');
    CollectionReference profile = _firestore.collection('profile');
    User? user = await FirebaseUsers().getCurrentUser();

    DocumentSnapshot documentSnapshot = await users.doc(user?.uid).get();
    print(documentSnapshot.data());
    UserModel userModel =
        UserModel().fromJSON(documentSnapshot.data() as Map<String, dynamic>);

    if (userModel.friends!.isNotEmpty) {
      num size = userModel.friends!.length ?? 0;
      List<UserFriends> friends = userModel.friends!;

      for (int i = 0; i < size; i++) {
        DocumentSnapshot documentSnapshot =
            await profile.doc(friends[i].uid).get();
        ProfileModel? userModel = ProfileModel()
            .fromJSON(documentSnapshot.data() as Map<String, dynamic>);

        if (userModel != null) {
          friendsList.add(FriendsList().fromJSON(
            chat_id: friends[i].chat_id,
            uid: userModel,
            created_at: friends[i].created_at,
            updated_at: friends[i].updated_at,
          ));
        }
      }
    }

    return friendsList;
  }

  Future<String> createChat(String friend) async {
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
