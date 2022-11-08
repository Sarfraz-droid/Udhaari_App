import 'package:flutter/cupertino.dart';

class ExpenseItem {
  final String? name;
  final String? message;
  bool checked;
  double? amount;
  final String? uid;
  final TextEditingController? amountController;
  bool isDirty;

  ExpenseItem(
      {this.name,
      this.message,
      this.amount,
      this.uid,
      this.amountController,
      this.isDirty = false,
      this.checked = false});

  toJSON() {
    return {
      "name": name,
      "amount": amount,
      "uid": uid,
      "isDirty": isDirty,
      "checked": checked,
    };
  }

  factory ExpenseItem.fromJSON(Map<String, dynamic> json) {
    print(json['amount']);
    return ExpenseItem(
      message: json['message'] ?? "",
      name: json['name'],
      amount: double.parse(json['amount'].toString()),
      uid: json['uid'],
      isDirty: json['isDirty'] ?? false,
    );
  }

  bool isPay() {
    return amount! < 0;
  }
}
