import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/expense/transactions/transactions_model.dart';
import 'package:udhaari/components/chats/dashboard/transactions/transaction_item.dart';
import 'package:udhaari/store/chats/chat.dart';

class TransactionsDashboard extends HookConsumerWidget {
  List<TransactionModel> transactions;
  TransactionsDashboard({super.key, required this.transactions});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chat = ref.watch(chatProvider.notifier);
    // final transactions = useState([]);

    // useEffect(() {
    //   print("TransactionsDashboard: useEffect");
    //   transactions.value = _chat.getTransactions();
    // }, []);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: ThemeData.light().primaryColor,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Text("Transactions",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                ],
              )),
        ),
        SizedBox(
          height: 200.0,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              TransactionModel transaction = transactions[index];

              return ListTile(
                leading: transaction.is_pending
                    ? Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 42,
                      )
                    : transaction.is_cancelled
                        ? Icon(Icons.cancel)
                        : Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                onTap: transaction.is_cancelled == false
                    ? () {
                        showModalBottomSheet(
                            context: context,
                            builder: ((context) {
                              return TransactionItem(
                                transaction: transaction,
                              );
                            }));
                      }
                    : null,
                title: Text(
                  '₹ ${transaction.amount.toString()}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
                subtitle: Text(
                  transaction.message,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                trailing: transaction.is_pending
                    ? const Text(
                        "Pending",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.red),
                      )
                    : transaction.is_cancelled
                        ? const Text(
                            "Cancelled",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey),
                          )
                        : const Text(
                            "Paid",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.green),
                          ),
              );
            },
          ),
        ),
      ],
    );
  }
}
