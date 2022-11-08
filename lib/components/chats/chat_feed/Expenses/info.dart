import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/classes/user.dart';
import 'package:udhaari/components/chats/dashboard/settle_expense.dart';
import 'package:udhaari/store/chats/chat.dart';

class ExpenseInfo extends HookWidget {
  const ExpenseInfo({
    Key? key,
    required this.expense,
    required ChatPod chat,
  })  : _chat = chat,
        super(key: key);

  final ExpenseModel expense;
  final ChatPod _chat;

  @override
  Widget build(BuildContext context) {
    final _userSettlements = useState<ExpenseItem?>(null);

    useEffect(() {
      _userSettlements.value = expense.receiver.firstWhere(
          (element) => element.uid == FirebaseAuth.instance.currentUser?.uid);
    }, [expense]);

    return SingleChildScrollView(
      child: Column(
        children: [
          Text("Paid By"),
          ListView.builder(
            itemCount: expense.sender.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: ((context, index) {
              print("chat len ${_chat.state.currentChat?.users?.length}");
              ProfileModel? user = _chat.state.currentChat?.users?.firstWhere(
                  (element) => element.uid == expense.sender[index].uid);
              return ListTile(
                title: Text('${user?.name}'),
                subtitle: Text('₹ ${expense.sender[index].amount}'),
              );
            }),
          ),
          SizedBox(
            height: 8,
          ),
          Text("Settlement"),
          ListView.builder(
            itemCount: expense.receiver.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: ((context, index) {
              ProfileModel? user = _chat.state.currentChat?.users?.firstWhere(
                  (element) => element.uid == expense.receiver[index].uid);
              return ListTile(
                title: Text('${user?.name}'),
                subtitle: Text(
                  '${!expense.receiver[index].isPay() ? "Gets" : "Pays"} ₹ ${expense.receiver[index].amount?.abs()}',
                  style: TextStyle(
                    color: !expense.receiver[index].isPay()
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
