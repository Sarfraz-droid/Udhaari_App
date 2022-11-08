import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/classes/user.dart';
import 'package:udhaari/components/chats/chat_feed/Expenses/display.dart';
import 'package:udhaari/components/chats/chat_feed/Expenses/info.dart';
import 'package:udhaari/components/chats/dashboard/settle_expense.dart';
import 'package:udhaari/store/chats/chat.dart';

class ExpenseDetails extends HookConsumerWidget {
  ExpenseModel expense;
  ExpenseDetails({super.key, required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chat = ref.watch(chatProvider.notifier);

    Future<bool> _onLoad() async {
      return true;
    }

    print('Expenses.dart ${expense.id}');

    return FutureBuilder(
        future: _onLoad(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ExpenseDisplay(
              expense: expense,
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}
