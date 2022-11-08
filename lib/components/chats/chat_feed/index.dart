import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/chat/chat_message.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/components/chats/chat_feed/ChatTypes/index.dart';
import 'package:udhaari/services/chats.dart';
import 'package:udhaari/services/hive/chat/dashboard.dart';
import 'package:udhaari/services/hive/chat/messages.dart';
import 'package:udhaari/store/chats/chat.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:dart_date/dart_date.dart';

class ChatFeed extends HookConsumerWidget {
  ChatFeed({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chats = ref.watch(chatProvider.notifier);
    final chat_list = useState<List<ChatMessage>>([]);
    final _scrollController = useState(ScrollController());
    final _chatisloading = useState(true);
    ChatService chatService = ChatService(chatId: _chats.state.currentChat!.id);
    final isMounted = useIsMounted();

    Future<void> _onLoad() async {
      print(HiveDashboard(id: _chats.state.currentChat!.id!)
          .getDashboard()
          .toJSON());

      chat_list.value =
          MessageHive(id: _chats.state.currentChat!.id!).getAllMessages();

      print(chat_list.value.length);

      chat_list.value.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return Future.value();
    }

    useEffect(() {
      _onLoad();

      if (_scrollController.value.hasClients) {
        _scrollController.value
            .jumpTo(_scrollController.value.position.maxScrollExtent);
      }

      return () {};
    }, []);

    useEffect(() {
      print("ChatFeed: useEffect called");
      if (_scrollController.value.hasClients) {
        _scrollController.value
            .jumpTo(_scrollController.value.position.maxScrollExtent);
      }
    }, [chat_list]);

    return FutureBuilder(
        future: _onLoad(),
        builder: (context, snapshot) {
          return StickyGroupedListView<dynamic, String>(
            elements: chat_list.value,
            groupBy: (dynamic element) => DateTime.parse(
                    Timestamp.fromMicrosecondsSinceEpoch(element.timestamp)
                        .toDate()
                        .toString())
                .format('dd MMMM yyyy'),
            groupSeparatorBuilder: (dynamic element) => SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          DateTime.parse(Timestamp.fromMillisecondsSinceEpoch(
                                      element.timestamp)
                                  .toDate()
                                  .toString())
                              .format('dd MMMM yyyy'),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300)),
                    ),
                  ],
                )),
            itemBuilder: (context, dynamic element) =>
                chatTypes[element.type]!(message: element),
            // itemComparator: (e1, e2) => e1['name'].compareTo(e2['name']), // optional
            elementIdentifier: (element) =>
                element.name, // optional - see below for usage
            order: StickyGroupedListOrder.ASC, // optional
          );
        });
  }
}
