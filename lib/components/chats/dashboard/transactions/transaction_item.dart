import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/classes/expense/transactions/transactions_model.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/components/chats/common/transaction_display.dart';
import 'package:udhaari/services/users.dart';
import 'package:udhaari/store/chats/chat.dart';

class TransactionItem extends HookConsumerWidget {
  TransactionModel transaction;
  TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chats = ref.watch(chatProvider.notifier);
    final _senderUser = useState<ProfileModel?>(null);
    final _receiverUser = useState<ProfileModel?>(null);
    final IsMounted = useIsMounted();

    Future<void> _loadUsers() async {
      _senderUser.value =
          await UsersService().getProfileByID(transaction.sender);
      _receiverUser.value =
          await UsersService().getProfileByID(transaction.receiver);
    }

    useEffect(() {
      _loadUsers();
    }, [transaction]);

    Future<void> cancelTransaction() async {
      await transaction.cancelTransaction(chat: _chats.state.currentChat!);
      if (IsMounted()) {
        Navigator.of(context).pop();
      }
    }

    Future<void> settleTransaction() async {
      await transaction.settleTransaction(chat: _chats.state.currentChat!);
      if (IsMounted()) {
        Navigator.of(context).pop();
      }
    }

    return Material(
      child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Transaction"),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                child: Text("Transaction ID: ${transaction.id}",
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "₹ ${transaction.amount}",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Date: ${DateTime.fromMillisecondsSinceEpoch(transaction.timestamp)}",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_senderUser.value != null && _receiverUser.value != null)
                TransactionDisplay(
                    sender: _senderUser.value!, receiver: _receiverUser.value!),
              Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (_receiverUser.value != null &&
                        _senderUser.value != null &&
                        _receiverUser.value?.uid ==
                            FirebaseAuth.instance.currentUser?.uid &&
                        transaction.is_cancelled == false &&
                        transaction.is_pending == true)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: settleTransaction,
                          child: Text("Confirm Transaction"),
                        ),
                      ),
                    if (_senderUser.value?.uid ==
                            FirebaseAuth.instance.currentUser?.uid &&
                        transaction.is_cancelled == false &&
                        transaction.is_pending == true)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: cancelTransaction,
                          child: Text("Cancel Transaction"),
                        ),
                      ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
