import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:udhaari/classes/chat/chat_message.dart';

import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/classes/user.dart';
import 'package:udhaari/services/hive/chat.dart';
import 'package:udhaari/services/users.dart';
import 'package:dartx/dartx.dart';

class ChatService {
  final String? chatId;
  ChatService({this.chatId});
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');
  final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('profile');

  final chats = Hive.box('chats');

  Future<ChatModel> getChatData() async {
    List<ProfileModel> users = [];

    final Map<String, dynamic> chatData =
        (await chatCollection.doc(chatId).get()).data() as Map<String, dynamic>;

    ChatModel chatEnum = ChatModel.fromJSON(chatData);

    for (String user in chatEnum.members!) {
      final Map<String, dynamic> userData =
          (await profileCollection.doc(user).get()).data()
              as Map<String, dynamic>;

      users.add(ProfileModel.fromJSON(userData));
    }

    chatEnum.users = users;

    User? currentUser = await UsersService().getCurrentUser();

    if (chatEnum.users!.length == 2) {
      // users.removeWhere((element) => element.uid == currentUser.uid);
      ProfileModel? _friend = users
          .filter((element) => element.uid != currentUser?.uid)
          .firstOrNull;
      if (_friend != null) {
        chatEnum.name = _friend.name;
      }
    }

    return chatEnum;
  }

  Future<void> createGroup({required ChatModel chat}) async {
    await chatCollection.doc(chat.id).set(chat.toJSON());
    return Future.value();
  }

  ChatModel loadChatModel() {
    return ChatModel.fromJSON(Map<String, dynamic>.from(chats.get(chatId)));
  }

  Future<List<ChatModel>> searchGroups({required String query}) async {
    final _chatSnapshotList =
        await chatCollection.where('joinCode', isEqualTo: query).get();
    List<ChatModel> _chatList = [];

    for (QueryDocumentSnapshot _chatSnapshot in _chatSnapshotList.docs) {
      Map<String, dynamic> _chatData =
          _chatSnapshot.data() as Map<String, dynamic>;
      ChatModel _chat = ChatModel.fromJSON(_chatData);
      _chatList.add(_chat);
    }
    return _chatList;
  }

  Future<void> joinRequestGroup({required ChatModel chatModel}) async {
    // ChatModel chat = loadChatModel();
    chatModel.members!.add(FirebaseAuth.instance.currentUser!.uid);
    chatModel.roles!.add(ChatRoles(
        roles: Roles.requester, uid: FirebaseAuth.instance.currentUser!.uid));
    await chatCollection.doc(chatModel.id).update(chatModel.toJSON());

    return Future.value();
  }

  Future<void> updateUserRole(String userId, Roles userRole) async {
    ChatModel chat = loadChatModel();
    for (int i = 0; i < chat.roles!.length; i++) {
      if (chat.roles![i].uid == userId) {
        chat.roles![i].roles = userRole;
      }
    }

    await chatCollection.doc(chat.id).update(chat.toJSON());

    return Future.value();
  }
}
