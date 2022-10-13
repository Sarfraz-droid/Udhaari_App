import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/chat.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/classes/profile.dart';

class ExpensesService {
  List<ExpenseItem> calculateExpense(
      {required List<ExpenseItem> expenses,
      required double total,
      required String paidBy,
      required ChatModel chat}) {
    double _n = double.parse(expenses.length.toString());
    double _count = _n;
    double totalamount = total;

    switch (paidBy) {
      case "Custom":
        for (int i = 0; i < _n; i++) {
          if (expenses[i].isDirty) {
            totalamount -= expenses[i].amount!;
            _count--;
          }
        }

        double _amount = totalamount / _count;
        for (int i = 0; i < _n; i++) {
          if (expenses[i].isDirty) continue;
          expenses[i].amount = _amount;
          expenses[i].isDirty = false;
        }

        return expenses;

      case "Equal":
        double _amount = totalamount / _count;

        for (int i = 0; i < _n; i++) {
          expenses[i].amount = _amount;
          expenses[i].isDirty = false;
        }

        print("Equal $_amount");
        return expenses;
    }
    if (chat == null) {
      return expenses;
    }

    for (ProfileModel _model in chat.users!) {
      print("Applying ${_model.name} ${_model.uid}");
      if (_model.uid == paidBy) {
        for (int i = 0; i < _n; i++) {
          if (expenses[i].uid == paidBy) {
            expenses[i].amount = totalamount;
            expenses[i].isDirty = false;
          } else {
            expenses[i].amount = 0;
            expenses[i].isDirty = false;
          }
        }
      }
    }

    return expenses;
  }

  List<ExpenseItem> calculateSettlements(
      {required List<ExpenseItem> settlements,
      required List<ExpenseItem> expenses,
      required double total,
      required ChatModel chat}) {
    double n = double.parse(settlements.length.toString());
    double count = n;
    double totalamt = total;
    double average = totalamt / count;

    print("Avg $average");

    for (int i = 0; i < n; i++) {
      print("Settle $average ${expenses[i].amount!}");
      settlements[i].amount = average - expenses[i].amount!;
      settlements[i].isDirty = false;
    }

    return settlements;
  }

  Future<void> addExpenseChat({
    required List<ExpenseItem> expenses,
  }) async {
    List<Map<String, dynamic>> _expenses = [];

    for (ExpenseItem expense in expenses) {
      _expenses.add(expense.toJSON());
    }
  }

  Future<ExpenseModel> getExpenseByID({required String id}) async {
    final CollectionReference expenseCollection =
        FirebaseFirestore.instance.collection("expenses");

    final Map<String, dynamic> expenseData =
        (await expenseCollection.doc(id).get()).data() as Map<String, dynamic>;

    return ExpenseModel.fromJSON(expenseData);
  }
}
