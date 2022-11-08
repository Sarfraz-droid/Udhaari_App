import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/components/chats/chat_feed/Expenses/info.dart';
import 'package:udhaari/store/chats/chat.dart';
import 'package:udhaari/store/dashboard/dashboard.dart';
import 'package:udhaari/store/settings/settings.dart';

class ExpenseDisplay extends HookConsumerWidget {
  ExpenseModel expense;
  ExpenseDisplay({
    Key? key,
    required this.expense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chat = ref.watch(chatProvider.notifier);
    final _dashboard = ref.watch(dashboardProvider.notifier);
    final _settings = ref.watch(settingsProvider.notifier);

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Expense Details',
                    style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                child: Text(
                  '"${expense.message}"',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (expense.iconId != null)
                    Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          color: _settings.getTag(expense.iconId!).color,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Text(
                        '${_settings.getTag(expense.iconId!)?.name ?? "No Tag"}',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text("Total Amount"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '₹ ${expense.amount.toString()}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TabBar(
                tabs: [
                  Tab(
                      icon: Icon(
                    Icons.info,
                    color: ThemeData().primaryColor,
                  )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ExpenseInfo(expense: expense, chat: _chat),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
