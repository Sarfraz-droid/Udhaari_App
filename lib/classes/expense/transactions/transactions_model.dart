import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/services/hive/chat/dashboard.dart';
import 'package:udhaari/services/hive/chat/transactions.dart';
import 'package:uuid/uuid.dart';

class TransactionModel {
  String? id;
  final double amount;
  final int timestamp;
  final String sender;
  final String receiver;
  bool is_pending;
  bool is_cancelled;
  final String message;

  TransactionModel({
    this.id,
    required this.amount,
    required this.timestamp,
    required this.sender,
    required this.receiver,
    required this.message,
    this.is_pending = true,
    this.is_cancelled = false,
  }) {
    if (id == null) {
      id = Uuid().v4();
    }
  }

  factory TransactionModel.fromJSON(Map<String, dynamic> json) {
    print(json);

    return TransactionModel(
      id: json['id'],
      amount: double.parse(json['amount'].toString()),
      timestamp: json['timestamp'],
      sender: json['sender'],
      receiver: json['receiver'],
      is_pending: json['is_pending'],
      message: json['message'],
      is_cancelled: json['is_cancelled'],
    );
  }

  Map<String, dynamic> toJSON({
    ExpenseModel? expense,
  }) {
    return {
      'id': id,
      'amount': amount,
      'timestamp': timestamp,
      'sender': sender,
      'receiver': receiver,
      'is_pending': is_pending,
      'is_cancelled': is_cancelled,
      'message': message,
    };
  }

  cancelTransaction({required ChatModel chat}) {
    if (id != null) HiveTransaction(chat: chat).cancelTransaction(tid: id!);
  }

  settleTransaction({required ChatModel chat}) {
    if (id != null) HiveTransaction(chat: chat).settleTransaction(tid: id!);
  }
}
