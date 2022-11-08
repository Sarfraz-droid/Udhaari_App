import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:uuid/uuid.dart';

class AddExpenseStoreState {
  String? id;
  final uuid = Uuid();
  double amount;
  List<ExpenseItem> paidBy;
  List<ExpenseItem> settlement;

  AddExpenseStoreState(
      {this.amount = 0.0,
      this.paidBy = const [],
      this.settlement = const [],
      this.id}) {
    id = uuid.v4();
  }

  copyWith({
    double? amount,
    List<ExpenseItem>? paidBy,
  }) {
    return AddExpenseStoreState(
      amount: amount ?? this.amount,
      paidBy: paidBy ?? this.paidBy,
    );
  }

  toJSON() {
    return {
      'id': id,
      'amount': amount,
      'paidBy': paidBy.map((e) => e.toJSON()).toList(),
      'settlement': settlement.map((e) => e.toJSON()).toList(),
    };
  }
}
