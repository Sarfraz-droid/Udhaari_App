import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/chat/chat_message.dart';
import 'package:udhaari/classes/expense/transactions/transactions_model.dart';
import 'package:udhaari/services/chats.dart';
import 'package:udhaari/services/expenses.dart';

class ChatState {
  List<ChatModel?>? chats;
  ChatModel? currentChat;
  List<ChatMessage>? currentChatMessages;
  ChatState({this.chats});

  factory ChatState.fromJSON(Map<String, dynamic> json) {
    return ChatState(
      chats: List<ChatModel>.from(json['chats']),
    );
  }

  addChat(ChatModel chat) {
    chats?.add(chat);
  }

  Future<ChatModel> loadChatData(String id) async {
    final chatHive = Hive.box('chats');

    ChatModel? chat =
        ChatModel.fromJSON(Map<String, dynamic>.from(chatHive.get(id)));

    return chat;
  }

  Future<void> loadDashboard() {
    return Future.value();
  }
}
