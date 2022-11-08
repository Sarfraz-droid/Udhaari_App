import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/profile.dart';

class TransactionDisplay extends HookConsumerWidget {
  ProfileModel sender;
  ProfileModel receiver;
  TransactionDisplay({super.key, required this.sender, required this.receiver});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (sender != null)
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  const Text(
                    "Sender",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                    radius: 30,
                    child: Text(sender.name.toString().substring(0, 2)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    sender.name.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          const Flexible(flex: 1, child: Icon(Icons.arrow_right_alt)),
          Flexible(
            flex: 1,
            child: Column(
              children: [
                const Text(
                  "Receiver",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 10,
                ),
                CircleAvatar(
                  radius: 30,
                  child: Text(receiver.name.toString().substring(0, 2)),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  receiver.name!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
