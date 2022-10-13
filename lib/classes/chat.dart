import 'package:firebase_auth/firebase_auth.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/classes/user.dart';
import 'package:udhaari/services/expenses.dart';
import 'package:udhaari/services/users.dart';

class ChatModel {
  final int? created_at;
  final int? updated_at;
  final String? id;
  final List<String>? members;

  // One to One chats

  // Group chat
  final bool? isGroup;

  String? groupName;
  final String? groupImage;

  // * Utils for UI
  // * Not in the database
  List<ProfileModel>? users;
  String? name;

  ChatModel(
      {this.created_at,
      this.updated_at,
      this.id,
      this.members,
      this.isGroup,
      this.groupImage,
      this.groupName,
      this.users,
      this.name});

  factory ChatModel.fromJSON(Map<String, dynamic> json) {
    return ChatModel(
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      id: json['id'],
      members: List<String>.from(json['members'] ?? []),
      isGroup: json['isGroup'],
      groupName: json['groupName'],
      groupImage: json['groupImage'],
    );
  }

  toJSON() {
    return {
      'created_at': created_at,
      'updated_at': updated_at,
      'id': id,
      'members': members,
      'isGroup': isGroup,
      'groupName': groupName,
      'groupImage': groupImage,
    };
  }

  Future<void> validateGroupName() async {
    if (groupName == null) {
      String uid = members!.firstWhere(
          (element) => element != FirebaseAuth.instance.currentUser?.uid);

      ProfileModel user = await FirebaseUsers().getProfileByID(uid);

      groupName = user.name;
    }
  }
}

class ChatMessage {
  String? expense_id;
  ExpenseModel? expense;
  int timestamp;
  String? message;
  String type;
  String? uid;

  ChatMessage(
      {this.expense_id,
      required this.timestamp,
      required this.type,
      this.message,
      this.uid});

  factory ChatMessage.fromJSON(Map<String, dynamic> json) {
    return ChatMessage(
      expense_id: json['expense_id'],
      timestamp: json['timestamp'],
      type: json['type'],
      message: json['message'],
      uid: json['uid'],
    );
  }

  Future<void> loadExpense() async {
    if (expense_id != null) {
      expense = await ExpensesService().getExpenseByID(id: expense_id!);
    }
  }

  String getMessage() {
    switch (type) {
      case "expense":
        return expense?.message ?? "Expense";
      case "settlement":
        return "Settlement added";
      case "message":
        return message!;
      default:
        return "Unknown message";
    }
  }

  toJSON() {
    return {
      'expense_id': expense_id,
      'timestamp': timestamp,
      'type': type,
      'message': message,
      'uid': uid,
    };
  }
}
