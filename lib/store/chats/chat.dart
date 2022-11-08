import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/chat/chat_message.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/classes/expense/transactions/transactions_model.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/services/expenses.dart';
import 'package:udhaari/services/hive/chat.dart';
import 'package:udhaari/services/hive/chat/transactions.dart';
import 'package:udhaari/store/chats/chat_state.dart';

final chatProvider = StateNotifierProvider((ref) {
  return ChatPod();
});

class ChatPod extends StateNotifier<ChatState> {
  ChatPod() : super(ChatState());

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

  getTag(String id) {
    return state.currentChat!.settings.tags
        .firstWhere((element) => element.id == id);
  }

  updateGroupName(String name) {
    state.currentChat!.groupName = name;
    HiveChat.updateChat(chat: state.currentChat!);
  }

  createGroup({
    required String name,
    required String description,
  }) {
    HiveChat.createGroup(name: name, description: description);
  }

  Future<void> requestTransaction(
      {required double amount, required ProfileModel user}) async {
    TransactionModel transactionModel = TransactionModel(
      amount: amount,
      sender: FirebaseAuth.instance.currentUser!.uid,
      receiver: user.uid!,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      is_cancelled: false,
      message:
          'Request for transaction from ${FirebaseAuth.instance.currentUser!.email} to ${user.email}',
    );

    HiveTransaction(chat: state.currentChat!)
        .requestTransaction(transaction: transactionModel);
  }

  List<TransactionModel> getTransactions() {
    return HiveTransaction(chat: state.currentChat!).getAllTransactions();
  }
}
