import 'package:udhaari/classes/expense/expense_item.dart';

class ExpenseModel {
  List<ExpenseItem> expenses;
  List<ExpenseItem> settlement;
  String message;
  bool is_settled;
  List<String> users;
  int timestamp;
  int total;

  ExpenseModel(
      {required this.expenses,
      required this.settlement,
      required this.message,
      required this.is_settled,
      required this.users,
      required this.timestamp,
      required this.total});

  factory ExpenseModel.fromJSON(Map<String, dynamic> json) {
    return ExpenseModel(
      expenses: List<ExpenseItem>.from(
          json['expenses'].map((x) => ExpenseItem.fromJSON(x))),
      settlement: List<ExpenseItem>.from(
          json['settlement'].map((x) => ExpenseItem.fromJSON(x))),
      message: json['message'] ?? "",
      is_settled: json['is_settled'],
      users: List<String>.from(json['users']),
      timestamp: json['timestamp'],
      total: json['total'],
    );
  }

  toJSON() {
    return {
      "expenses": List<dynamic>.from(expenses.map((x) => x.toJSON())),
      "settlement": List<dynamic>.from(settlement.map((x) => x.toJSON())),
      "message": message,
      "is_settled": is_settled,
      "users": List<dynamic>.from(users.map((x) => x)),
      "timestamp": timestamp,
      "total": total,
    };
  }
}
