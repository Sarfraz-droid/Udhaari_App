import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/expense/transactions/transactions_model.dart';
import 'package:udhaari/services/expenses.dart';
import 'package:uuid/uuid.dart';

class ExpenseModel {
  List<ExpenseItem> sender;
  List<ExpenseItem> receiver;
  List<TransactionModel>? transactions;
  
  String message;
  List<String> users;
  int timestamp;
  double amount;
  String? iconId;
  String? id;
  final uuid = Uuid();

  ExpenseModel(
      {this.sender = const [],
      this.receiver = const [],
      this.message = '',
      this.users = const [],
      this.timestamp = 0,
      this.amount = 0,
      this.id,
      this.iconId,
      this.transactions}) {
    id ??= uuid.v4();
  }

  factory ExpenseModel.fromJSON(Map<String, dynamic> json) {
    List<ExpenseItem> _expense = [];

    if (json['sender'] != null) {
      for (int i = 0; i < json['sender'].length; i++) {
        print(json['sender'][i]);

        _expense.add(
            ExpenseItem.fromJSON(Map<String, dynamic>.from(json['sender'][i])));
      }
    }

    return ExpenseModel(
      sender: _expense,
      iconId: json['iconId'],
      id: json['id'],
      receiver: List<ExpenseItem>.from(json['receiver']
          .map((x) => ExpenseItem.fromJSON(Map<String, dynamic>.from(x)))),
      message: json['message'] ?? "",
      users: List<String>.from(json['users']),
      timestamp: json['timestamp'],
      amount: double.parse(json['total'].toString()),
    );
  }

  toJSON() {
    return {
      "sender": List<dynamic>.from(sender.map((x) => x.toJSON())),
      "receiver": List<dynamic>.from(receiver.map((x) => x.toJSON())),
      "message": message,
      "users": List<dynamic>.from(users.map((x) => x)),
      "timestamp": timestamp,
      "total": amount,
      "id": id,
      "iconId": iconId,
    };
  }
}
