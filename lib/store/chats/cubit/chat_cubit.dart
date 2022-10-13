import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:udhaari/classes/chat.dart';
import 'package:udhaari/services/chats.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState());

  void addChat(ChatModel chat) {
    state.addChat(chat);
  }

  Future<ChatModel> loadChatData(String id) async {
    ChatModel _chat = await state.loadChatData(id);
    state.chats?.add(_chat);
    return _chat;
  }

  updateCurrentChat(ChatModel chat) {
    state.currentChat = chat;
  }

  updateCurrentChatMessages(List<ChatMessage> messages) {
    state.currentChatMessages = messages;
  }
}
