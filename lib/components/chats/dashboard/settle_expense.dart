import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/components/chats/common/transaction_display.dart';
import 'package:udhaari/store/chats/chat.dart';

class SettleExpense extends HookConsumerWidget {
  double maxAmount;
  ProfileModel usertoPay;
  SettleExpense({super.key, required this.maxAmount, required this.usertoPay});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final IsMounted = useIsMounted();
    final _userChosen = useState<ProfileModel?>(null);
    final _chat = ref.watch(chatProvider.notifier);
    final _settler = useState<TextEditingController>(TextEditingController());
    final _amountleft = useState<double>(0);
    final _me = _chat.state.currentChat?.users?.firstWhere(
        (element) => element.uid == FirebaseAuth.instance.currentUser!.uid);

    useEffect(() {
      _settler.value.text = maxAmount.toString();
    }, []);

    void UpdateAmount(String text) {
      double amt = double.parse(text);

      if (amt > maxAmount) {
        _settler.value.text = maxAmount.toString();
        _amountleft.value = 0;
      } else {
        _amountleft.value = maxAmount - amt;
      }
    }

    Future<void> requestTransaction() async {
      await _chat.requestTransaction(
          amount: double.parse(_settler.value.text), user: usertoPay);

      if (IsMounted()) Navigator.of(context).pop();

      return Future.value();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 50,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Settle Expense",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Pays",
                        textAlign: TextAlign.center,
                        style: TextStyle(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("₹"),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              controller: _settler.value,
                              onChanged: (value) {
                                // _settler.value.text = value;
                                UpdateAmount(value);
                              },
                              style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              decoration: const InputDecoration(
                                hintText: "Enter Amount",
                                border: InputBorder.none,
                                alignLabelWithHint: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  children: [
                    Text(
                      "On Successful",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "You have to pay ₹ ${_amountleft.value} more",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                TransactionDisplay(sender: _me!, receiver: usertoPay),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              requestTransaction();
                            },
                            child: Text("Request Settlement"),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: TextButton(
                            onPressed: () {},
                            child: Text("Cancel"),
                          ),
                        ),
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
