import 'dart:convert';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/chat/chat_list.dart';
import 'package:udhaari/classes/friends_list.dart';
import 'package:udhaari/classes/user_friends.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/classes/user.dart';
import 'package:udhaari/screens/profile.dart';

class UsersService {
  final uuid = Uuid();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final users = Hive.box('users');
  final chats = Hive.box('chats');

  Future<UserCredential> login(String email, String password) async {
    try {
      UserCredential credentials = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credentials;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  List<String> addCaseSearch(String name, List<String> caseSearch) {
    String temp = "";
    for (int i = 0; i < name.length; i++) {
      temp = temp + name[i];
      caseSearch.add(temp.toLowerCase());
    }
    return caseSearch;
  }

  Future<UserCredential> register(
      String email, String password, String name) async {
    try {
      print("Registering");
      CollectionReference profile = _firestore.collection('profile');
      CollectionReference users = _firestore.collection('users');
      print("Registering user");
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print("User registered");
      await credentials.user?.updateDisplayName(name);
      print("User name updated");
      List<String> caseSearchList = [];
      String parsedEmail = email.replaceAll(RegExp('@.*'), '');
      caseSearchList = addCaseSearch(parsedEmail, caseSearchList);
      caseSearchList = addCaseSearch(name, caseSearchList);
      await profile.doc(credentials.user?.uid).set({
        'uid': credentials.user?.uid,
        'email': credentials.user?.email,
        'name': name,
        'photo': credentials.user?.photoURL,
        'case_search': caseSearchList
      });

      await users.doc(credentials.user?.uid).set({
        'friends': [],
        'chats': [],
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      });

      print("User created");
      return credentials;
    } catch (e) {
      print('Error Occurred on _register $e');
      throw e;
    }
  }

  void logout() {
    _auth.signOut();
  }

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<List<ProfileModel?>> findUsers({email}) async {
    print("Finding users with $email");
    List<ProfileModel?> users = [];
    QuerySnapshot querySnapshot = await _firestore
        .collection('profile')
        .where(
          'case_search',
          arrayContains: email,
        )
        .get();
    querySnapshot.docs.forEach((doc) {
      users.add(ProfileModel().fromJSON(doc.data() as Map<String, dynamic>));
    });

    return users;
  }

  Future<UserModel> getUserByID(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(uid).get();
    return UserModel.fromJSON(documentSnapshot.data() as Map<String, dynamic>);
  }

  Future<ProfileModel> getProfileByID(String uid) async {
    DocumentSnapshot documentSnapshot =
        await _firestore.collection('profile').doc(uid).get();
    if (documentSnapshot.data() == null) {
      return ProfileModel();
    }
    return ProfileModel()
        .fromJSON(documentSnapshot.data() as Map<String, dynamic>);
  }

  // Future<List<ChatList>> getChatList() async {
  //   List<ChatList> chatList = [];
  //   User? user = await getCurrentUser();
  //   QuerySnapshot documentSnapshot = await _firestore
  //       .collection('chats')
  //       .where(
  //         'members',
  //         arrayContains: user?.uid,
  //       )
  //       .get();

  //   print("Chat list length ${documentSnapshot.docs.length}");
  //   // documentSnapshot.docs.forEach((doc) async {
  //   //   ChatList cl = ChatList();
  //   //   ChatModel chat = ChatModel.fromJSON(doc.data() as Map<String, dynamic>);

  //   //   cl.chat = chat;
  //   //   QuerySnapshot lastMessageSnapshot = await _firestore
  //   //       .collection('chats')
  //   //       .doc(chat.id)
  //   //       .collection('messages')
  //   //       .orderBy('created_at', descending: true)
  //   //       .limit(1)
  //   //       .get();

  //   //   if (lastMessageSnapshot.docs.length > 0) {
  //   //     cl.lastMessage = ChatMessage.fromJSON(
  //   //         lastMessageSnapshot.docs[0].data() as Map<String, dynamic>);
  //   //   }

  //   //   chatList.add(cl);
  //   // });

  //   for (int i = 0; i < documentSnapshot.docs.length; i++) {
  //     ChatList cl = ChatList();
  //     ChatModel chat = ChatModel.fromJSON(
  //         documentSnapshot.docs[i].data() as Map<String, dynamic>);
  //     cl.chat = chat;
  //     QuerySnapshot lastMessageSnapshot = await _firestore
  //         .collection('chats')
  //         .doc(chat.id)
  //         .collection('messages')
  //         .orderBy('timestamp', descending: true)
  //         .limit(1)
  //         .get();

  //     await cl.chat?.validateGroupName();

  //     print(lastMessageSnapshot.docs.length);

  //     if (lastMessageSnapshot.docs.isNotEmpty) {
  //       cl.lastMessage = ChatMessage.fromJSON(
  //           lastMessageSnapshot.docs[0].data() as Map<String, dynamic>);
  //     }
  //     await cl.lastMessage?.loadExpense();
  //     chatList.add(cl);
  //   }

  //   print("Chat_list length ${chatList.length}");
  //   return chatList;
  // }

  Future<List<ChatList>?> getChatList() async {
    // await chats.deleteAll(chats.keys);
    List<ChatList>? chatList = [];
    print('Getting chat list : getChatList()');
    chats.values.forEach((element) {
      ChatModel ch = ChatModel.fromJSON(Map<String, dynamic>.from(element));
      ch.validateGroupName();

      ChatList cl = ChatList();
      cl.chat = ch;

      chatList.add(cl);
    });

    return chatList;
  }

  Future<void> updateToken(String token) async {
    if (FirebaseAuth.instance.currentUser != null) {

      FirebaseFunctions.instance.httpsCallable('updateToken').call({
        'token': token,
        'uid': FirebaseAuth.instance.currentUser!.uid,
      });
      print('Token updated');
    }
  }
}
