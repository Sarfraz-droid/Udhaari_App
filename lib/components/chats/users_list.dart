import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/chat.dart';

@immutable
class UsersList extends HookWidget {
  int? totalAmount;
  List<ExpenseItem>? expense;
  ChatModel? chat;
  Function? onUserAmountChange;
  String? hint;
  bool isSettlement;
  UsersList(
      {super.key,
      this.chat,
      this.expense,
      this.totalAmount,
      this.onUserAmountChange,
      this.hint,
      this.isSettlement = false});

  @override
  Widget build(BuildContext context) {
    final _totalAmount = useState(totalAmount);
    final _expenses = useState(<ExpenseItem>[for (var i in expense!) i]);

    return Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: chat?.users?.length ?? 0,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: const CircleAvatar(
                    child: ClipOval(
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 8,
                  fit: FlexFit.tight,
                  child: Text(
                    chat?.users?[index].name ?? "Unknown",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  fit: FlexFit.tight,
                  child: isSettlement
                      ? Container(
                          child: Text(
                            "${_expenses.value[index].amount! >= 0 ? "gives" : "gets"} ${_expenses.value[index].amount?.abs()}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _expenses.value[index].amount! >= 0
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        )
                      : TextField(
                          controller: TextEditingController(
                            text: _expenses.value[index].amount.toString(),
                          ),
                          onChanged: ((value) {
                            onUserAmountChange!(index, value);
                          }),
                          decoration: InputDecoration(
                              hintText: "Amt", border: InputBorder.none),
                          keyboardType: TextInputType.number,
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
