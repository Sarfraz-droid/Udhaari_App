import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/chat.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/classes/user.dart';
import 'package:udhaari/services/users.dart';
import 'package:dartx/dartx.dart';

class FirebaseChat {
  final String? uid;
  FirebaseChat({this.uid});
  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');
  final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('profile');

  Future<ChatModel> getChatData() async {
    List<ProfileModel> users = [];

    final Map<String, dynamic> chatData =
        (await chatCollection.doc(uid).get()).data() as Map<String, dynamic>;

    ChatModel chatEnum = ChatModel.fromJSON(chatData);

    for (String user in chatEnum.members!) {
      final Map<String, dynamic> userData =
          (await profileCollection.doc(user).get()).data()
              as Map<String, dynamic>;

      users.add(ProfileModel.fromJSON(userData));
    }

    chatEnum.users = users;

    User? currentUser = await FirebaseUsers().getCurrentUser();

    if (chatEnum.users!.length == 2) {
      // users.removeWhere((element) => element.uid == currentUser.uid);
      ProfileModel? _friend = users
          .filter((element) => element.uid != currentUser?.uid)
          .firstOrNull;
      if (_friend != null) {
        chatEnum.name = _friend.name;
      }
    }

    return chatEnum;
  }

  Future<void> addExpense({
    required int total,
    required List<ExpenseItem> expenses,
    required List<ExpenseItem> settlement,
    required ChatModel chat,
  }) async {
    final CollectionReference expenseCollection =
        FirebaseFirestore.instance.collection("expenses");

    final String expenseId = expenseCollection.doc().id;

    print("Expense id: $expenseId");
    await expenseCollection.doc(expenseId).set({
      "total": total,
      "message": "Expense added",
      "expenses": expenses.map((e) => e.toJSON()).toList(),
      "settlement": settlement.map((e) => e.toJSON()).toList(),
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "is_settled": false,
      "users": chat.users?.map((e) => e.uid).toList(),
    });

    await chatCollection.doc(uid).collection("messages").add({
      "type": "expense",
      "expense_id": expenseId,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "uid": FirebaseAuth.instance.currentUser!.uid,
    });

    print("Expense added");

    return Future.value();
  }

  Future<void> addMessage({required String message, ChatModel? chat}) async {
    await chatCollection.doc(uid).collection("messages").add({
      "type": "message",
      "message": message,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "uid": FirebaseAuth.instance.currentUser!.uid
    });

    return Future.value();
  }

  Future<List<ChatMessage>> getChatMessages({required ChatModel chat}) async {
    QuerySnapshot _query = await chatCollection
        .doc(uid)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(10)
        .get();

    List<ChatMessage> messages = [];

    for (QueryDocumentSnapshot _doc in _query.docs) {
      Map<String, dynamic> _data = _doc.data() as Map<String, dynamic>;

      ChatMessage _message = ChatMessage.fromJSON(_data);
      await _message.loadExpense();

      messages.add(_message);
    }

    messages = messages.reversed.toList();
    return messages;
  }
}
