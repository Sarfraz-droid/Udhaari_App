import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/services/hive/chat/dashboard.dart';
import 'package:udhaari/store/add_expense/add_expense_state.dart';

class ExpensesHive {
  String id;
  late Box<dynamic> expensesBox;
  ExpensesHive({required this.id}) {
    expensesBox = Hive.box('chats_${id}_expenses');
  }

  Future<void> open() async {
    if (!Hive.isBoxOpen('chats_${id}_expenses')) {
      await Hive.openBox('chats_${id}_expenses');
    }
  }

  getId() {
    return id;
  }

  addExpense({required ExpenseModel expense}) {
    expensesBox.put(expense.id, expense.toJSON());

    HiveDashboard(id: id).onAddExpense(expense: expense);
  }

  ExpenseModel getExpense({required String eid}) {
    final expense = Map<String, dynamic>.from(expensesBox.get(eid));

    return ExpenseModel.fromJSON(expense);
  }
}
