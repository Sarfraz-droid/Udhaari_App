import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/chat.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/classes/user.dart';
import 'package:udhaari/components/Layout/nav_appbar.dart';
import 'package:udhaari/components/chats/addExpenseModal.dart';
import 'package:udhaari/components/chats/chat_feed/index.dart';
import 'package:udhaari/components/navbar.dart';
import 'package:udhaari/hooks/useAsyncEffect.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:udhaari/services/chats.dart';

class ChatComponent extends HookWidget {
  ChatModel? chat;
  bool _keyboardVisible = false;
  ChatComponent({super.key, this.chat});

  @override
  Widget build(BuildContext context) {
    final _keyboard = useState(false);
    final _message = useState(TextEditingController(text: ""));
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    Future<void> onAddExpense(int total, List<ExpenseItem> expenses,
        List<ExpenseItem> settled) async {
      print(total);
      print(expenses);
      print(settled);

      await FirebaseChat(uid: chat?.id!).addExpense(
          total: total, expenses: expenses, settlement: settled, chat: chat!);

      return Future.value();
    }

    return Navbar(
      title: chat?.name ?? "Unknown",
      appBar: NavAppBar(
        onSearchChange: (value) {
          print(value);
        },
        title: chat?.name ?? "Unknown",
        showBackButton: true,
      ),
      showBottomNav: false,
      child: Column(
        children: [
          Flexible(flex: 6, child: ChatFeed()),
          Flexible(
            flex: _keyboardVisible ? 2 : 1,
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 5,
                              child: TextField(
                                controller: _message.value,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Type a message",
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Center(
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    print("Sending $_message");
                                    if (_message.value == "") return;
                                    FirebaseChat(uid: chat?.id!).addMessage(
                                      message: _message.value.text,
                                      chat: chat!,
                                    );
                                    _message.value.text = "";
                                  },
                                  color: Theme.of(context).primaryColor,
                                  icon: const Icon(Icons.send),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(elevation: 0),
                          onPressed: () {
                            showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => AddExpenseModal(
                                  chat: chat, onAddExpense: onAddExpense),
                            );
                          },
                          child: Text("+ Expense"),
                        ))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
