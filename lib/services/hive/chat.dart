import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/chat/chat_settings.dart';
import 'package:udhaari/config/Chat/defaultTags.dart';
import 'package:udhaari/services/chats.dart';
import 'package:udhaari/services/hive/chat/dashboard.dart';
import 'package:udhaari/services/hive/chat/settings.dart';
import 'package:uuid/uuid.dart';

class HiveChat {
  static Future<void> updateChat({required ChatModel chat}) async {
    var chatBox = Hive.box('chats');
    chatBox.put(chat.id, chat.toJSON());
  }

  static Future<void> createGroup(
      {required String name, required String description}) async {
    var chatBox = Hive.box('chats');

    ChatModel chat = ChatModel(
      groupName: name,
      id: Uuid().v4(),
      groupDescription: description,
      roles: [
        ChatRoles(
          roles: Roles.admin,
          uid: FirebaseAuth.instance.currentUser!.uid,
        )
      ],
      members: [FirebaseAuth.instance.currentUser!.uid],
      isGroup: true,
      settings: ChatSettings(
        tags: defaultTags
      )
    );

    await chat.generateJoiningLink();

    await ChatService().createGroup(chat: chat);
    await Hive.openBox('chats_${chat.id}');

    await HiveDashboard(id: chat.id).setupDashboard(chat: chat);
    
    chatBox.put(chat.id, chat.toJSON());
  }

  static Future<void> joinGroup({required ChatModel group}) async {
    var chatBox = Hive.box('chats');
    await Hive.openBox('chats_${group.id}');

    await HiveDashboard(id: group.id).setupDashboard(chat: group);
    await HiveSettings(id: group.id).setupSettings();

    chatBox.put(group.id, group.toJSON());
  }

  static ChatModel getChat({required String id}) {
    var chatBox = Hive.box('chats');

    return ChatModel.fromJSON(Map<String, dynamic>.from(chatBox.get(id)));
  }
}
