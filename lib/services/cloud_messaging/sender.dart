import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/chat/chat_message.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/classes/expense/transactions/transactions_model.dart';
import 'package:udhaari/classes/profile.dart';

class FirebaseNotificationSender {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> sendExpense({
    required ChatMessage message,
    required ChatModel chat,
    required ExpenseModel expense,
  }) async {
    FirebaseFunctions functions = FirebaseFunctions.instance;

    HttpsCallable callable = functions.httpsCallable('sendExpense');

    List<String> members = getMembers(chat: chat);

    ProfileModel sender = chat.users!.firstWhere(
        (element) => element.uid == FirebaseAuth.instance.currentUser?.uid);

    String title = getTitle(sender: sender, chat: chat);
    String body = getBody(sender: sender, chat: chat) + ': Added an expense';

    await callable.call(<String, dynamic>{
      'message': message.toJSON(),
      'chat': chat.toJSON(),
      'members': members,
      'expense': expense.toJSON(),
      'notification': {
        'title': title,
        'body': body,
      }
    });
  }

  static Future<void> updateTransaction({
    required TransactionModel transaction,
    required ChatModel chat,
  }) async {
    FirebaseFunctions functions = FirebaseFunctions.instance;
// updateTransaction

    HttpsCallable callable = functions.httpsCallable('updateTransaction');

    ProfileModel sender = chat.users!.firstWhere(
        (element) => element.uid == FirebaseAuth.instance.currentUser?.uid);

    List<String> members = getMembers(chat: chat);

    String title = '';
    String body = '';
    title = getTitle(sender: sender, chat: chat);

    if (transaction.is_cancelled) {
      body = getBody(sender: sender, chat: chat) +
          ': Cancelled a settlement request';
    } else if (transaction.is_pending == false) {
      body = getBody(sender: sender, chat: chat) +
          ': Accepted a settlement request';
    } else {
      body = getBody(sender: sender, chat: chat) + ': Requested a settlement';
    }

    await callable.call(<String, dynamic>{
      'transaction': transaction.toJSON(),
      'chat': chat.toJSON(),
      'members': members,
      'notification': {
        'title': title,
        'body': body,
      }
    });

    return Future.value();
  }

  static getTitle({
    required ProfileModel sender,
    required ChatModel chat,
  }) {
    if (chat.isGroup! == true) {
      return chat.groupName!;
    } else {
      return sender.name!;
    }
  }

  static getBody({
    required ProfileModel sender,
    required ChatModel chat,
  }) {
    if (chat.isGroup! == true) {
      return '${sender.name}';
    } else {
      return '';
    }
  }

  static List<String> getMembers({
    required ChatModel chat,
  }) {
    List<String> members = chat.members!
        .where((element) => element != FirebaseAuth.instance.currentUser!.uid)
        .toList();

    return members;
  }
}
