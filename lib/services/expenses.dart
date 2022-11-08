import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/classes/expense/transactions/transactions_model.dart';
import 'package:udhaari/classes/profile.dart';

class ExpensesService {
  List<ExpenseItem> calculateExpense(
      {required List<ExpenseItem> expenses,
      required double total,
      required ChatModel chat}) {
    double _n = double.parse(expenses.length.toString());
    double _count = _n;
    double totalamount = total;

    for (int i = 0; i < _n; i++) {
      if (!expenses[i].checked)
        _count = _count - 1;
      else if (expenses[i].isDirty) {
        totalamount -= expenses[i].amount!;
        _count--;
      }
    }

    double _amount = totalamount / _count;
    print('Service: totalamount: $totalamount');
    print('Service: amountperuser: $_amount');
    for (int i = 0; i < _n; i++) {
      if (expenses[i].isDirty || !expenses[i].checked) continue;
      expenses[i].amount = _amount;
      expenses[i].isDirty = false;
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

    print(id);
    final Map<String, dynamic> expenseData =
        (await expenseCollection.doc(id).get()).data() as Map<String, dynamic>;

    return ExpenseModel.fromJSON(expenseData);
  }

  void ExpenseListener(
      {required String id,
      required Function(ExpenseModel) onExpenseUpdate}) async {
    final CollectionReference expenseCollection =
        FirebaseFirestore.instance.collection("expenses");

    expenseCollection.doc(id).snapshots().listen((event) {
      onExpenseUpdate(
          ExpenseModel.fromJSON(event.data() as Map<String, dynamic>));
    });
  }

  Future<List<TransactionModel>> fetchTransactions({required String id}) async {
    final CollectionReference expenseCollection =
        FirebaseFirestore.instance.collection("expenses");

    print(id);

    QuerySnapshot _transactionSnapshot =
        await expenseCollection.doc(id).collection("transactions").get();

    List<TransactionModel> _transactions = [];

    for (QueryDocumentSnapshot _snapshot in _transactionSnapshot.docs) {
      _transactions.add(
          TransactionModel.fromJSON(_snapshot.data() as Map<String, dynamic>));
    }

    return _transactions;
  }

  Future<void> requestTransaction(
      {required TransactionModel transactionModel,
      required String expense_id}) async {
    final CollectionReference expenseCollection =
        FirebaseFirestore.instance.collection("expenses");
    print('Transaction ID : ${transactionModel.id}');
    await expenseCollection
        .doc(expense_id)
        .collection("transactions")
        .doc(transactionModel.id)
        .set(transactionModel.toJSON()
          ..removeWhere((key, value) => value == null));
  }

  void ListenTransactions(id, callback) {
    final CollectionReference expenseCollection =
        FirebaseFirestore.instance.collection("expenses");

    expenseCollection
        .doc(id)
        .collection("transactions")
        .snapshots()
        .listen((event) {
      List<TransactionModel> _transactions = [];

      for (QueryDocumentSnapshot _snapshot in event.docs) {
        _transactions.add(TransactionModel.fromJSON(
            _snapshot.data() as Map<String, dynamic>));
      }

      callback(_transactions);
    });
  }

  void listenExpenseByID({
    required String id,
    required Function(ExpenseModel) onExpenseUpdate,
  }) async {
    final CollectionReference expenseCollection =
        FirebaseFirestore.instance.collection("expenses");

    expenseCollection.doc(id).snapshots().listen((event) {
      onExpenseUpdate(
          ExpenseModel.fromJSON(event.data() as Map<String, dynamic>));
    });
  }
}
