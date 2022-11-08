import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/chat/chat_message.dart';
import 'package:udhaari/classes/chat/chat_settings.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/classes/expense/transactions/transactions_model.dart';
import 'package:udhaari/services/friends.dart';
import 'package:udhaari/services/hive/chat.dart';
import 'package:udhaari/services/hive/chat/dashboard.dart';
import 'package:udhaari/services/hive/chat/expenses.dart';
import 'package:udhaari/services/hive/chat/messages.dart';
import 'package:udhaari/services/hive/chat/settings.dart';
import 'package:udhaari/services/hive/chat/transactions.dart';

class FirebaseNotificationsReciever {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void dataHandler(Map<String, dynamic> data) {
    print("Data Handler");

    final type = data['type'];

    switch (type) {
      case 'create_chat':
        print("Create Chat");
        createChat(
          chat: Map<String, dynamic>.from(jsonDecode(data['chat'])),
          settings: Map<String, dynamic>.from(jsonDecode(data['settings'])),
        );

        break;
      case 'new_message':
        print("New Message");
        break;
      case 'create_expense':
        print("Create Expense");
        createExpense(
          chat: Map<String, dynamic>.from(jsonDecode(data['chat'])),
          message: Map<String, dynamic>.from(jsonDecode(data['message'])),
          expense: Map<String, dynamic>.from(jsonDecode(data['expense'])),
        );
        break;
      case 'update_transaction':
        print('Update Transaction');
        updateTransaction(
          chat: Map<String, dynamic>.from(jsonDecode(data['chat'])),
          transaction:
              Map<String, dynamic>.from(jsonDecode(data['transaction'])),
        );
        break;
      case 'new_order':
        print("New Order");
        break;

      case 'update_group':
        print("Update Group");
        updateGroup(
          chat: Map<String, dynamic>.from(jsonDecode(data['chat'])),
          settings: Map<String, dynamic>.from(jsonDecode(data['settings'])),
        );
        break;
      default:
        print("Unknown Type");
    }
  }

  Future<void> updateTransaction({
    required Map<String, dynamic> chat,
    required Map<String, dynamic> transaction,
  }) async {
    print("Update Transaction : Inside");
    ChatModel chatModel = ChatModel.fromJSON(chat);
    TransactionModel transactionModel = TransactionModel.fromJSON(transaction);

    await HiveTransaction(chat: chatModel).open();
    HiveTransaction(chat: chatModel)
        .setTransaction(transaction: transactionModel, notify: false);
  }

  Future<void> createExpense({
    required Map<String, dynamic> expense,
    required Map<String, dynamic> chat,
    required Map<String, dynamic> message,
  }) async {
    ChatModel chatModel = ChatModel.fromJSON(chat);
    ChatMessage chatMessage = ChatMessage.fromJSON(message);
    ExpenseModel expenseModel = ExpenseModel.fromJSON(expense);

    print(chatModel.toJSON());
    print(chatMessage.toJSON());
    print(expenseModel.toJSON());
    await Hive.openBox('chats_${chatModel.id}');
    // await MessageHive(id: chatModel.id).open();
    await Hive.openBox('chats_${chatModel.id}_messages');
    MessageHive(id: chatModel.id).addMessage(message: chatMessage);
    print("Message added");

    // await ExpensesHive(id: chatModel.id).open();
    await Hive.openBox('chats_${chatModel.id}_expenses');
    ExpensesHive(id: chatModel.id).addExpense(expense: expenseModel);
    print("Expense added");

    return Future.value();
  }

  Future<void> createChat({
    required Map<String, dynamic> chat,
    required Map<String, dynamic> settings,
  }) async {
    ChatModel chatModel = ChatModel.fromJSON(chat);
    ChatSettings chatSettings = ChatSettings.fromJSON(settings);
    await chatModel.validateGroupName();
    await Hive.openBox('chats_${chatModel.id}');
    HiveChat.updateChat(chat: chatModel);
    HiveSettings.updateSettings(chatId: chatModel.id!, settings: chatSettings);
    await Hive.openBox('chats_${chatModel.id}_dashboard_udhaari');

    HiveDashboard(id: chatModel.id).setupDashboard(chat: chatModel);
  }

  Future<void> updateGroup({
    required Map<String, dynamic> chat,
    required Map<String, dynamic> settings,
  }) async {
    ChatModel chatModel = ChatModel.fromJSON(chat);
    ChatSettings chatSettings = ChatSettings.fromJSON(settings);
    await chatModel.validateGroupName();
    await Hive.openBox('chats_${chatModel.id}');
    HiveChat.updateChat(chat: chatModel);
    HiveDashboard(id: chatModel.id).updateDashboard(chat: chatModel);

    HiveSettings.updateSettings(chatId: chatModel.id, settings: chatSettings);
  }
}
