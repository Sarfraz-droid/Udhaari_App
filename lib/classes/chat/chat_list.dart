import 'package:udhaari/classes/chat.dart';

class ChatList {

  ChatModel? chat;
  ChatMessage? lastMessage;

  ChatList({
    this.chat,
    this.lastMessage,
  });

  factory ChatList.fromJSON(Map<String, dynamic> json) {
    return ChatList(
      chat: ChatModel.fromJSON(json['chat']),
      lastMessage: ChatMessage.fromJSON(json['lastMessage']),
    );
  }

  toJSON() {
    return {
      'chat': chat!.toJSON(),
      'lastMessage': lastMessage!.toJSON(),
    };
  }
}
