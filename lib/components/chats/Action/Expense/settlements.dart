import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/store/add_expense/add_expense.dart';

class AddExpenseSettlement extends HookConsumerWidget {
  const AddExpenseSettlement({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addExpenseStore = ref.watch(addExpenseProvider.notifier);

    useEffect(() {
      addExpenseStore.setupSettlement();
    }, [addExpenseStore.state.receiver]);

    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: addExpenseStore.state.receiver.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${addExpenseStore.state.receiver[index].name}'),
            subtitle: Row(
              children: [
                Text(
                  '${addExpenseStore.state.receiver[index].amount! < 0 ? "Pays" : "Gets"} ${addExpenseStore.state.receiver[index].amount?.abs().toString()}',
                  style: TextStyle(
                      color: addExpenseStore.state.receiver[index].amount! < 0
                          ? Colors.red
                          : Colors.green),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
