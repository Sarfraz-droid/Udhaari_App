import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/services/chats.dart';
import 'package:udhaari/services/expenses.dart';
import 'package:udhaari/services/hive/chat/expenses.dart';
import 'package:uuid/uuid.dart';

class ChatMessage {
  String id;
  String? expense_id;
  ExpenseModel? expense;
  int timestamp;
  String? message;
  String type;
  String? uid;

  final uuid = Uuid();

  ChatMessage(
      {this.expense_id,
      this.id = '',
      required this.timestamp,
      required this.type,
      this.message,
      this.uid}) {
    id = uuid.v4();
  }

  factory ChatMessage.fromJSON(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      expense_id: json['expense_id'],
      timestamp: json['timestamp'],
      type: json['type'],
      message: json['message'],
      uid: json['uid'],
    );
  }

  Future<void> loadExpense({
    required String chat_id,
  }) async {
    if (expense_id != null) {
      expense = ExpensesHive(id: chat_id).getExpense(eid: expense_id!);
    }
  }

  String getMessage() {
    switch (type) {
      case "expense":
        return expense?.message ?? "Expense";
      case "settlement":
        return "Settlement added";
      case "message":
        return message!;
      default:
        return "Unknown message";
    }
  }

  toJSON() {
    return {
      'id': id,
      'expense_id': expense_id,
      'timestamp': timestamp,
      'type': type,
      'message': message,
      'uid': uid,
    };
  }
}
