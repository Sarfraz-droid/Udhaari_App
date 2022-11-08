import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/chat/chat_message.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/components/chats/chat_feed/ChatTypes/UI/chat_bubble.dart';
import 'package:udhaari/components/chats/chat_feed/Expenses/details.dart';
import 'package:udhaari/components/chats/index.dart';
import 'package:dart_date/dart_date.dart';
import 'package:udhaari/store/chats/chat.dart';
import 'package:udhaari/store/dashboard/dashboard.dart';
import 'package:udhaari/store/settings/settings.dart';

class ExpenseType extends HookConsumerWidget {
  ChatMessage message;
  ExpenseType({super.key, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chat = ref.watch(chatProvider.notifier);
    final dashboardStore = ref.watch(dashboardProvider.notifier);
    final _settings = ref.watch(settingsProvider.notifier);
    final _message = useState(message);

    useEffect(() {
      print(
          'Expense_Type ${_message.value.expense?.id} , ${message.expense?.id} ${message.expense?.iconId}');
    }, [message]);

    final _settlement = message.expense?.receiver.firstWhere(
        (element) => element.uid == FirebaseAuth.instance.currentUser!.uid);

    final _expense = message.expense?.sender
        .firstWhere((element) => element.uid == message.uid!);

    final _tag = _chat.getTag(message.expense!.iconId!);

    return Container(
        child: ListTile(
      title: Text(
        '${message.message}',
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _tag.icon,
            color: _tag.color,
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Opacity(
            opacity: 0.8,
            child: Text(
              'By ${FirebaseAuth.instance.currentUser!.uid == message.uid ? "You" : _expense?.name}',
              style: TextStyle(
                color: _tag.color,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => ExpenseDetails(
                  expense: message.expense!,
                ));
      },
    ));
  }
}

class ExpensesWidget extends HookWidget {
  bool isSender;
  ExpensesWidget(
      {Key? key,
      required ExpenseItem? settlement,
      required this.message,
      this.isSender = true})
      : _settlement = settlement,
        super(key: key);

  final ExpenseItem? _settlement;
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    print(message.expense?.iconId);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${(_settlement?.amount ?? 0) < 0 ? "You get" : "You give"} ",
            style: TextStyle(color: Colors.white),
          ),
        ),
        Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          color: isSender ? Colors.blue[400] : Colors.grey[700],
          child: Text(
            "₹ ${_settlement?.amount?.abs()}",
            style: TextStyle(
                color: (_settlement?.amount ?? 0) > 0
                    ? Colors.red[100]
                    : Colors.green[100],
                fontSize: 24,
                fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text("For",
                  style: TextStyle(
                    color: Colors.white,
                  )),
              const SizedBox(
                height: 8,
              ),
              Text('"${message.expense?.message ?? "No Message"}"',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) => ExpenseDetails(
                      expense: message.expense!,
                    ),
                isScrollControlled: true);
          },
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: isSender
                ? MaterialStateProperty.all(Colors.blue[500])
                : MaterialStateProperty.all(Colors.grey[500]),
          ),
          child: Container(
            padding: EdgeInsets.all(8),
            width: double.infinity,
            child: Row(
              children: const [
                Text(
                  "Created by You",
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
