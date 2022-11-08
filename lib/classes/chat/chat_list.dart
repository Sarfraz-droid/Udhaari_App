import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/chat/chat_message.dart';

class ChatList {

  ChatModel? chat;
  ChatMessage? lastMessage;

  ChatList({
    this.chat,
    this.lastMessage,
  });

  factory ChatList.fromJSON(Map<String, dynamic> json) {
    return ChatList(
      chat: ChatModel.fromJSON(json),
      lastMessage: json['chat'] != null
          ? ChatMessage.fromJSON(json['lastMessage'])
          : null,
    );
  }

  toJSON() {
    return {
      'chat': chat!.toJSON(),
      'lastMessage': lastMessage!.toJSON(),
    };
  }
}
