import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/expense/transactions/transactions_model.dart';
import 'package:udhaari/components/chats/dashboard/transactions/index.dart';
import 'package:udhaari/store/chats/chat.dart';

class TransactionDashboardContainer extends ConsumerWidget {
  String chatId;
  TransactionDashboardContainer({super.key, required this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chat = ref.watch(chatProvider.notifier);
    return ValueListenableBuilder(
        valueListenable: Hive.box('chats_${chatId}_transactions').listenable(),
        builder: (context, value, child) {
          print("TransactionDashboardContainer: ValueListenableBuilder called");

          List<TransactionModel> _transactions = _chat.getTransactions();
          print(
              'TransactionDashboardContainer: _transactions.length: ${_transactions.length}');
          return TransactionsDashboard(
            transactions: _transactions,
          );
        });
  }
}
