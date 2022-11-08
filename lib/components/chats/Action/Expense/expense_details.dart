import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat_tags.dart';
import 'package:udhaari/components/chats/Action/Expense/expense_hook.dart';
import 'package:udhaari/store/add_expense/add_expense.dart';
import 'package:udhaari/store/chats/chat.dart';
import 'package:udhaari/store/dashboard/dashboard.dart';
import 'package:udhaari/store/settings/settings.dart';

class AddExpenseDetails extends HookConsumerWidget {
  AddExpenseDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseStore = ref.watch(addExpenseProvider.notifier);
    final dashboardStore = ref.watch(dashboardProvider.notifier);
    final settingsStore = ref.watch(settingsProvider.notifier);
    final chatStore = ref.watch(chatProvider.notifier);

    final iconId = useState<String?>(null);

    useEffect(() {
      print('AddExpenseDetails: useEffect called with iconId: ${iconId.value}');
      if (iconId.value != null) expenseStore.updateIconId(iconId.value!);
    }, [iconId.value]);

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
              hintText: "Enter the amount",
              labelText: "Total Amount",
              border: OutlineInputBorder()),
          onChanged: ((value) {
            print('AddExpenseDetails: value: $value');
            expenseStore.updateTotalAmount(value);
          }),
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          decoration: InputDecoration(
              hintText: "Enter the message",
              labelText: "Message",
              border: OutlineInputBorder()),
          onChanged: ((value) {
            print('AddExpenseDetails: value: $value');
            expenseStore.updateMessage(value);
          }),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Text(
                "Tag",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(width: 20),
              DropdownButton(
                value: iconId.value,
                onChanged: (value) {
                  print('AddExpenseDetails: value: $value');
                  ChatTags tag = chatStore.state.currentChat!.settings.tags
                      .firstWhere((element) => element.id == value);

                  print(tag.toJSON());
                  iconId.value = value;
                },
                items: [
                  for (ChatTags tag
                      in chatStore.state.currentChat!.settings.tags)
                    DropdownMenuItem(
                      value: tag.id,
                      child: Row(
                        children: [
                          Icon(tag.icon),
                          SizedBox(
                            width: 10,
                          ),
                          Text(tag.name),
                        ],
                      ),
                    )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
