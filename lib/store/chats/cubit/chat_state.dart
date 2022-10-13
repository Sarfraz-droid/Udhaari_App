part of 'chat_cubit.dart';

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
    ChatModel chat = await FirebaseChat(uid: id).getChatData();
    return chat;
  }
}
