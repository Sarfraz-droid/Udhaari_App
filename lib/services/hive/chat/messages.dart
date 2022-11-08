import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/chat/chat_message.dart';

class MessageHive {
  String id;
  late Box<dynamic> _box;
  MessageHive({required this.id}) {
    _box = Hive.box('chats_${id}_messages');
  }

  Future<void> open() async {
    if (!Hive.isBoxOpen('chats_${id}_messages')) {
      await Hive.openBox('chats_${id}_messages');
    }
  }

  getId() {
    return id;
  }

  addMessage({required ChatMessage message}) {
    _box.put(message.id, message.toJSON());
    print(_box.values.length);
  }

  getAllMessages() {
    List<ChatMessage> messages = [];
    _box.toMap().forEach((key, value) {
      ChatMessage msg = ChatMessage.fromJSON(Map<String, dynamic>.from(value));
      msg.id = key as String;

      if (msg.type == "expense") {
        msg.loadExpense(chat_id: id);
      }

      messages.add(msg);
    });
    return messages;
  }

  deleteAll() {
    _box.deleteAll(_box.keys);
  }
}
