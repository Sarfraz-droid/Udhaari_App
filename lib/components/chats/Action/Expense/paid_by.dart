import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/services/expenses.dart';
import 'package:udhaari/store/add_expense/add_expense.dart';
import 'package:udhaari/store/chats/chat.dart';

class AddExpensePaidBy extends HookConsumerWidget {
  const AddExpensePaidBy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatStore = ref.watch(chatProvider.notifier);
    final addExpenseStore = ref.watch(addExpenseProvider.notifier);

    final paidBy = useState<List<ExpenseItem>>(chatStore
        .state.currentChat!.users!
        .map((e) => ExpenseItem(
            uid: e.uid,
            name: e.name,
            amount: 0,
            amountController: TextEditingController(text: '0')))
        .toList());

    useEffect(() {
      addExpenseStore.setupPaidBy();
    }, []);

    useEffect(() {
      print("AddExpensePaidBy: useEffect: ");
    }, [addExpenseStore.state]);

    useEffect(() {
      print("AddExpensePaidBy: useEffect: paidBy");
      addExpenseStore.state.sender = paidBy.value;
    }, [paidBy.value]);

    void calculateExpenses() {
      double total = double.parse(addExpenseStore.state.amount.toString());

      List<ExpenseItem> expenses = ExpensesService().calculateExpense(
        expenses: [...paidBy.value],
        total: total,
        chat: chatStore.state.currentChat!,
      );

      for (int i = 0; i < expenses.length; i++) {
        expenses[i].amountController?.text = expenses[i].amount.toString();
      }

      paidBy.value = expenses;
    }

    void updatePaidByAmount({required ExpenseItem e, required double amount}) {
      e.amount = amount;
      e.amountController?.text = amount.toString();
      e.isDirty = true;

      calculateExpenses();
    }

    return Column(
      key: UniqueKey(),
      children: [
        Text('Total Amount: ${addExpenseStore.state.amount}'),
        ListView.builder(
          shrinkWrap: true,
          itemCount: paidBy.value.length,
          itemBuilder: (context, index) {
            ExpenseItem e = paidBy.value[index];
            print('Paid By ...  :${e.name} : ${e.amount}');
            return CheckboxListTile(
              // secondary: e.checked
              //     ? IconButton(
              //         onPressed: () {
              //           showModalBottomSheet(
              //               context: context,
              //               builder: ((context) {
              //                 return Container(
              //                   padding: EdgeInsets.all(10),
              //                   child: Column(
              //                     children: [
              //                       Padding(
              //                         padding: const EdgeInsets.all(8.0),
              //                         child: Text('Update Paid Amount',
              //                             style: TextStyle(fontSize: 20)),
              //                       ),
              //                       TextField(
              //                         decoration: InputDecoration(
              //                           hintText: "Enter the amount",
              //                           border: OutlineInputBorder(
              //                             borderRadius:
              //                                 BorderRadius.circular(20),
              //                           ),
              //                         ),
              //                         controller: TextEditingController(
              //                             text: e.amount.toString()),
              //                         onChanged: ((value) {
              //                           if (value == '')
              //                             e.amount = 0;
              //                           else
              //                             e.amount = double.parse(value);
              //                           updatePaidByAmount(
              //                               e: e, amount: e.amount!);
              //                         }),
              //                         keyboardType: TextInputType.number,
              //                       ),
              //                     ],
              //                   ),
              //                 );
              //               }));
              //         },
              //         icon: Icon(Icons.edit),
              //       )
              //     : null,
              title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${e.name}'),
                    SizedBox(height: 5),
                    Text(
                      '${e.amount}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ]),
              value: e.checked,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                paidBy.value = paidBy.value.map((element) {
                  if (element.name == e.name) {
                    element.checked = value!;
                  }

                  if (element.checked == false) {
                    element.amount = 0;
                    element.isDirty = false;
                  }

                  return element;
                }).toList();
                calculateExpenses();
              },
            );
          },
        )
      ],
    );
  }
}
