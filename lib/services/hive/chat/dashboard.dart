import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/chat/chat_dashboard.dart';
import 'package:udhaari/classes/chat/chat_udhaar.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/classes/expense/transactions/transactions_model.dart';
import 'package:udhaari/services/hive/chat.dart';

class HiveDashboard {
  String id;
  late Box<dynamic> dashboardBox;

  HiveDashboard({required this.id}) {
    dashboardBox = Hive.box('chats_$id');
  }

  /*
     Dashboard Description:

    ! For Udhaars
    * The key is the user's id
    * The value is the udhaar amount
    * if the value is negative, it means the user has to pay to the current user
    * if the value is positive, it means the current user has to pay to the user

  */

  setDashboard({
    required ChatDashboard dashboard,
  }) {
    dashboardBox.put('dashboard', dashboard.toJSON());
  }

  onAddExpense({
    required ExpenseModel expense,
  }) {
    dashboardBox.put('last_updated', DateTime.now().toIso8601String());
    ChatDashboard dashboard = getDashboard();
    int count = 0;

    for (ExpenseItem item in expense.sender) {
      if (item.amount! <= 0) continue;
      count++;
    }

    for (ExpenseItem item in expense.sender) {
      if (item.amount! <= 0) continue;
      if (item.uid == FirebaseAuth.instance.currentUser!.uid) {
        // if you are the sender, then receivers will be the ones who owe you
        for (ExpenseItem ruser in expense.receiver) {
          if (ruser.uid == FirebaseAuth.instance.currentUser!.uid) continue;

          ChatUdhaar uudhaar = dashboard.udhaar['${ruser.uid}']!;
          uudhaar.amount += ruser.amount! / count;
          dashboard.udhaar['${ruser.uid}'] = uudhaar;
        }
      }
    }

    for (ExpenseItem item in expense.receiver) {
      if (item.uid == FirebaseAuth.instance.currentUser!.uid &&
          item.amount! < 0) {
        // if you are the receiver, then senders will be the ones who you owe
        for (ExpenseItem suser in expense.sender) {
          ChatUdhaar uudhaar = dashboard.udhaar['${suser.uid}']!;

          if (suser.uid != FirebaseAuth.instance.currentUser!.uid) {
            print(
                'Doing ${(item.amount!) / count} as ${suser.uid} at ${item.amount}');
            uudhaar.amount -= (item.amount!) / count;
          }

          dashboard.udhaar['${suser.uid}'] = uudhaar;
        }
      }
    }

    setDashboard(dashboard: dashboard);
  }

  Future<void> setupDashboard({required ChatModel chat}) async {
    ChatDashboard dashboard = ChatDashboard(udhaar: {});

    for (String uid in chat.members!) {
      dashboard.udhaar['$uid'] = ChatUdhaar(
        amount: 0,
      );
    }

    print(dashboard.toJSON());

    dashboardBox.put('dashboard', dashboard.toJSON());
  }

  Future<void> updateDashboard({required ChatModel chat}) async {
    ChatDashboard dashboard = getDashboard();

    for (String uid in chat.members!) {
      if (dashboard.udhaar['$uid'] == null) {
        dashboard.udhaar['$uid'] = ChatUdhaar(
          amount: 0,
        );
      }
    }

    setDashboard(dashboard: dashboard);
  }

  Future<void> handleTransaction({required TransactionModel transaction}) {
    dashboardBox.put('last_updated', DateTime.now().toIso8601String());

    if (transaction.is_cancelled == true || transaction.is_pending == true) {
      return Future.value();
    }
    
    ChatDashboard dashboard = getDashboard();

    if (transaction.sender == FirebaseAuth.instance.currentUser!.uid) {
      // if you are the sender, then receivers will be the ones who owe you
      String ruser = transaction.receiver;
      ChatUdhaar uudhaar = dashboard.udhaar['$ruser']!;
      uudhaar.amount -= transaction.amount;
    } else if (transaction.receiver == FirebaseAuth.instance.currentUser!.uid) {
      // if you are the receiver, then senders will be the ones who you owe
      String suser = transaction.sender;
      ChatUdhaar uudhaar = dashboard.udhaar['$suser']!;
      uudhaar.amount += transaction.amount;
    }

    setDashboard(dashboard: dashboard);
    return Future.value();
  }

  ChatDashboard getDashboard() {
    Map<String, dynamic> dashboardJSON;

    if (!dashboardBox.containsKey('dashboard')) {
      ChatModel chatModel = HiveChat.getChat(id: id);
      setupDashboard(chat: chatModel);
    }

    dashboardJSON = Map<String, dynamic>.from(dashboardBox.get('dashboard'));
    return ChatDashboard.fromJSON(
        Map<String, dynamic>.from(dashboardBox.get('dashboard')));
  }

  void saveDashboard({required ChatDashboard dashboard}) {
    dashboardBox.put('dashboard', dashboard.toJSON());
  }
}
