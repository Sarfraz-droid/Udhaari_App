import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/components/chats/Action/Expense/users_list.dart';
import 'package:udhaari/services/expenses.dart';

class AddExpenseModal extends HookWidget {
  ChatModel chat;
  Function onAddExpense;
  AddExpenseModal({super.key, required this.chat, required this.onAddExpense});

  @override
  Widget build(BuildContext context) {
    final totalAmount = useState(0);
    final _expenses = useState(<ExpenseItem>[]);
    final _settled = useState(<ExpenseItem>[]);
    final _paidBy = useState<String?>("Equal");

    useEffect(() {
      List<ExpenseItem>? _init = chat?.users
          ?.map((e) => ExpenseItem(
                name: e.name,
                uid: e.uid,
                amount: 0,
              ))
          .toList();

      _expenses.value = chat?.users
          ?.map((e) => ExpenseItem(
                name: e.name,
                uid: e.uid,
                amount: 0,
              ))
          .toList() as List<ExpenseItem>;
      _settled.value = chat?.users
          ?.map((e) => ExpenseItem(
                name: e.name,
                uid: e.uid,
                amount: 0,
              ))
          .toList() as List<ExpenseItem>;
    }, []);

    useEffect(() {
      print('useEffect called ${totalAmount.value}');
      return () {
        print('useEffect disposed');
      };
    }, [totalAmount]);

    void calculateExpense({required double total}) {
      List<ExpenseItem> expenses = ExpensesService().calculateExpense(
        chat: chat,
        expenses: _expenses.value,
        // paidBy: _paidBy.value!,
        total: double.parse(totalAmount.value.toString()),
      );

      _expenses.value = expenses;
    }

    void settleExpense() {
      print("Settling Expense");
      List<ExpenseItem> settledExpenses =
          ExpensesService().calculateSettlements(
        chat: chat,
        expenses: _expenses.value.toList(),
        settlements: _settled.value.toList(),
        total: double.parse(totalAmount.value.toString()),
      );

      _settled.value = settledExpenses;
    }

    print('build called ${_paidBy.value}');
    useEffect(() {
      print('useEffect called ${_paidBy.value}');

      calculateExpense(total: totalAmount.value.toDouble());
      settleExpense();
      print("Paid by  ${_settled.value[0].amount}");

      return () {
        print('useEffect disposed');
      };
    }, [_paidBy.value, totalAmount.value]);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
                child: Text(
                  "Add Expense",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Enter Expense Amount",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  Center(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Amount',
                      ),
                      onChanged: ((value) {
                        if (value == "") return;
                        _paidBy.value = "Custom";

                        totalAmount.value = int.parse(value);
                      }),
                      keyboardType: TextInputType.number,
                    ),
                  )
                ],
              ),
              Divider(),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Paid By",
                          style: Theme.of(context).textTheme.subtitle1),
                      SizedBox(width: 10),
                      DropdownButton(
                        value: _paidBy.value,
                        onChanged: (value) {
                          print(value);
                          _paidBy.value = value.toString();
                        },
                        items: [
                          const DropdownMenuItem(
                            child: Text("Split Equally"),
                            value: "Equal",
                          ),
                          const DropdownMenuItem(
                            child: Text("Custom"),
                            value: "Custom",
                          ),
                          for (var user in chat?.users ?? [])
                            DropdownMenuItem(
                              child: Text(user.name ?? ""),
                              value: user.chatId.toString(),
                            ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              UsersList(
                chat: chat,
                expense: _expenses.value,
                hint: "Amt",
                totalAmount: totalAmount.value,
                onUserAmountChange: (value, index) {
                  print("Dirty $value");
                  if (value == "") return;

                  _expenses.value[index].amount = double.parse(value);
                  _expenses.value[index].isDirty = true;
                },
              ),
              Divider(),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Settled As",
                          style: Theme.of(context).textTheme.subtitle1),
                    ],
                  ),
                ),
              ),
              UsersList(
                chat: chat,
                expense: _settled.value,
                hint: "Amt",
                totalAmount: totalAmount.value,
                isSettlement: true,
                onUserAmountChange: (index, value) {
                  // print("Dirty $value");
                  // if (value == "") return;

                  // print("$index $value");
                  // _settled.value[index].amount = double.parse(value);
                  // _settled.value[index].isDirty = true;

                  // settleExpense();
                },
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(elevation: MaterialStateProperty.all(0)),
                  onPressed: () {
                    onAddExpense(
                        totalAmount.value, _expenses.value, _settled.value);
                    Navigator.pop(context);
                  },
                  child: const Text("Add Expense"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
