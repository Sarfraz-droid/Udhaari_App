import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/chat/chat_message.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/services/cloud_messaging/sender.dart';
import 'package:udhaari/services/hive/chat/expenses.dart';
import 'package:udhaari/services/hive/chat/messages.dart';
import 'package:udhaari/store/chats/chat.dart';
import 'package:udhaari/store/chats/chat_state.dart';

final addExpenseProvider = StateNotifierProvider((ref) {
  return AddExpenseActionPod(
    chatStore: ref.watch(chatProvider.notifier),
  );
});

class AddExpenseActionPod extends StateNotifier<ExpenseModel> {
  ChatPod chatStore;
  AddExpenseActionPod({
    required this.chatStore,
  }) : super(ExpenseModel());

  void addExpense() {
    ChatMessage newMessage = ChatMessage(
      timestamp: DateTime.now().millisecondsSinceEpoch,
      type: 'expense',
      expense_id: state.id,
      message: state.message,
      uid: FirebaseAuth.instance.currentUser!.uid,
    );
    MessageHive(id: chatStore.state.currentChat!.id!)
        .addMessage(message: newMessage);

    print("Message added");

    ExpensesHive(id: chatStore.state.currentChat!.id!)
        .addExpense(expense: state);

    print("Expense added");

    print(state.toJSON());

    FirebaseNotificationSender.sendExpense(
        message: newMessage,
        chat: chatStore.state.currentChat!,
        expense: state);

    state = ExpenseModel();
  }

  void updateTotalAmount(String amount) {
    print("Update Total Amount");
    if (amount == "") {
      state.amount = 0.0;
    } else {
      state.amount = double.parse(amount);
    }
  }

  void updateMessage(String message) {
    state.message = message;
  }

  updateIconId(String iconId) {
    state.iconId = iconId;
    state = state;
  }

  void setupPaidBy() {
    print("Setup Paid By");

    state.sender = chatStore.state.currentChat!.users!.map((e) {
      return ExpenseItem(
        name: e.name,
        uid: e.uid,
        amount: 0,
      );
    }).toList();
  }

  void setupSettlement() {
    print("Setup Settlement");

    final total = state.amount;
    final count = state.receiver.length;
    double amount = total / count;
    final settlements = state.sender.map((e) {
      return ExpenseItem(
          name: e.name,
          uid: e.uid,
          amount: (e.amount! - amount),
          checked: true);
    }).toList();

    state.receiver = settlements;
  }

  void CheckPaidBy(int index) {
    print("Check Paid By $index");

    List<ExpenseItem> pays = [...state.sender];
    pays[index].checked = !pays[index].checked;

    state.sender = pays;
  }
}
