import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat_udhaar.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/components/chats/dashboard/settle_expense.dart';
import 'package:udhaari/services/hive/chat/dashboard.dart';
import 'package:udhaari/store/chats/chat.dart';

class YourUdhaars extends HookConsumerWidget {
  final Map<String, ChatUdhaar> udhaari;
  YourUdhaars({super.key, required this.udhaari});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chats = ref.watch(chatProvider.notifier);
    useEffect(() {}, []);

    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: ThemeData.light().primaryColor,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: const Text("Your UDHAARs",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400)),
                    ),
                  ],
                )),
          ),
          ListView.builder(
            itemCount: udhaari.entries.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              ProfileModel profile = _chats.state.currentChat!.users!
                  .firstWhere((element) =>
                      element.uid == udhaari.entries.elementAt(index).key);

              if (profile.uid == FirebaseAuth.instance.currentUser!.uid) {
                return Container();
              }

              ChatUdhaar udhaar = udhaari.entries.elementAt(index).value;

              return ListTile(
                title: Text('${profile.name}'),
                trailing: Text(
                  '${udhaar.amount > 0 ? "You have to pay" : "${profile.name} has to pay"}  ₹ ${udhaar.amount.abs()}',
                  style: TextStyle(
                      color: udhaar.amount > 0 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),
                subtitle: udhaar.amount > 0 ? Text('Tap to pay') : null,
                onTap: () {
                  if (udhaar.amount > 0) {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: ((context) {
                          return SettleExpense(
                            maxAmount: udhaar.amount,
                            usertoPay: profile,
                          );
                        }));
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
