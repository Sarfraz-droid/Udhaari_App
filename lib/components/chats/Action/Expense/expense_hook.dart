import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/expense/expense_item.dart';

class ExpenseHook {
  double totalAmount;
  ChatModel chat;
  int currentStep;
  List<ExpenseItem>? paidBy;
  List<ExpenseItem>? settled;

  ExpenseHook(
      {required this.totalAmount,
      required this.chat,
      this.currentStep = 0,
      this.paidBy,
      this.settled}) {
    paidBy = chat.users
        ?.map((e) => ExpenseItem(
              name: e.name,
              uid: e.uid,
              amount: 0,
            ))
        .toList() as List<ExpenseItem>;
    settled = chat.users
        ?.map((e) => ExpenseItem(
              name: e.name,
              uid: e.uid,
              amount: 0,
            ))
        .toList() as List<ExpenseItem>;
  }

  updateTotalAmount(String amount) {
    totalAmount = double.parse(amount);
  }
}

ValueNotifier<ExpenseHook> useAddExpense({
  required ChatModel chat,
}) {
  final state = useState(ExpenseHook(totalAmount: 0, chat: chat));

  return state;
}
