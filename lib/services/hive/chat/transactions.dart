import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/expense/transactions/transactions_model.dart';
import 'package:udhaari/services/cloud_messaging/sender.dart';
import 'package:udhaari/services/hive/chat/dashboard.dart';

class HiveTransaction {
  ChatModel chat;
  late Box<dynamic> box;

  HiveTransaction({required this.chat}) {
    box = Hive.box('chats_${chat.id}_transactions');
  }

  getId() {
    return chat.id;
  }

  Future<void> open() async {
    if (!Hive.isBoxOpen('chats_${chat.id}_transactions')) {
      await Hive.openBox('chats_${chat.id}_transactions');
    }
  }

  setTransaction({required TransactionModel transaction, bool notify = true}) {
    box.put(transaction.id, transaction.toJSON());

    if (notify) {
      FirebaseNotificationSender.updateTransaction(
        transaction: transaction,
        chat: chat,
      );
    }

    HiveDashboard(id: chat.id).handleTransaction(transaction: transaction);
  }

  TransactionModel getTransaction({required String tid}) {
    final transaction = new Map<String, dynamic>.from(box.get(tid));

    return TransactionModel.fromJSON(transaction);
  }

  List<TransactionModel> getAllTransactions() {
    List<TransactionModel> transactions = [];

    for (var key in box.keys) {
      transactions.add(getTransaction(tid: key));
    }

    return transactions;
  }

  requestTransaction({required TransactionModel transaction}) {
    print('requestTransaction ${transaction.toJSON()}');
    setTransaction(transaction: transaction);
  }

  settleTransaction({required String tid}) {
    TransactionModel transaction = getTransaction(tid: tid);
    transaction.is_pending = false;
    setTransaction(transaction: transaction);
  }

  cancelTransaction({required String tid}) {
    TransactionModel transaction = getTransaction(tid: tid);
    transaction.is_pending = false;
    transaction.is_cancelled = true;
    setTransaction(transaction: transaction);
  }
}
