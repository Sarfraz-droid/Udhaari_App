import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat_udhaar.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/components/chats/dashboard/transactions/index.dart';
import 'package:udhaari/components/chats/dashboard/transactions/transactions.container.dart';
import 'package:udhaari/components/chats/dashboard/udhaars/udhaar.container.dart';
import 'package:udhaari/components/chats/dashboard/udhaars/your_udhaars.dart';
import 'package:udhaari/services/hive/chat/dashboard.dart';
import 'package:udhaari/store/chats/chat.dart';

class Dashboard extends HookConsumerWidget {
  const Dashboard({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final udhaari = useState<Map<String, ChatUdhaar>>({});
    final _chats = ref.watch(chatProvider.notifier);
    useEffect(() {
      udhaari.value = HiveDashboard(id: _chats.state.currentChat!.id!)
          .getDashboard()
          .udhaar;
    }, []);

    return Container(
      child: Column(children: [
        Divider(),
        UdhaarContainer(chatId: _chats.state.currentChat!.id!),
        Divider(),
        TransactionDashboardContainer(chatId: _chats.state.currentChat!.id!)
      ]),
    );
  }
}
