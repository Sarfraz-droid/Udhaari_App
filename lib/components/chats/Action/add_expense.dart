import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/components/chats/Action/Expense/expense_details.dart';
import 'package:udhaari/components/chats/Action/Expense/expense_hook.dart';
import 'package:udhaari/components/chats/Action/Expense/paid_by.dart';
import 'package:udhaari/components/chats/Action/Expense/settlements.dart';
import 'package:udhaari/components/chats/Action/Expense/users_paid_by_list.dart';
import 'package:udhaari/components/chats/chat_feed/Expenses/details.dart';
import 'package:udhaari/store/add_expense/add_expense.dart';
import 'package:udhaari/store/chats/chat.dart';

class AddExpenseContainer extends HookConsumerWidget {
  const AddExpenseContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(chatProvider.notifier);
    final addExpenseStore = ref.watch(addExpenseProvider.notifier);
    final expenseData = useState(0);

    Future<void> expenseSubmitHandler() {
      addExpenseStore.addExpense();
      // print(addExpenseStore.state.toJSON());
      GoRouter.of(context).pop();
      return Future.value();
    }

    return Stepper(
      currentStep: expenseData.value,
      controlsBuilder: ((context, details) {
        return Container(
          margin: EdgeInsets.all(10),
          child: Row(children: [
            SizedBox(
              width: 100,
              child: TextButton(
                onPressed: () {
                  if (expenseData.value > 0) {
                    expenseData.value--;
                  }
                },
                child: Text("Back"),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  if (expenseData.value < 2) {
                    expenseData.value++;
                  } else {
                    expenseSubmitHandler();
                  }
                },
                child: Text('${expenseData.value < 2 ? "Next" : "Done"}'),
              ),
            ),
          ]),
        );
      }),
      onStepContinue: () {
        if (expenseData.value < 3) {
          expenseData.value++;
        }
      },
      onStepCancel: () {
        expenseData.value--;
      },
      onStepTapped: (value) {
        expenseData.value = value;
      },
      elevation: 0,
      steps: [
        Step(
            isActive: expenseData.value >= 0,
            title: Text("Expense Details"),
            content: AddExpenseDetails()),
        Step(
            isActive: expenseData.value >= 1,
            title: Text("Paid By"),
            content: AddExpensePaidBy()),
        Step(
          isActive: expenseData.value >= 2,
          title: Text("Settlements"),
          content: AddExpenseSettlement(),
        ),
      ],
    );
  }
}
