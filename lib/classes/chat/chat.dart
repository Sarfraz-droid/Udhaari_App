import 'dart:convert' as convert;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:nanoid/async.dart';
import 'package:udhaari/classes/chat/chat_settings.dart';
import 'package:udhaari/classes/expense/expense_item.dart';
import 'package:udhaari/classes/expense/expense_model.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/classes/user.dart';
import 'package:udhaari/config/env.dart';
import 'package:udhaari/services/chats.dart';
import 'package:udhaari/services/expenses.dart';
import 'package:udhaari/services/hive/chat/expenses.dart';
import 'package:udhaari/services/users.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

enum Roles { admin, member, requester }

class ChatRoles {
  Roles roles;
  String uid;

  ChatRoles({required this.roles, required this.uid});

  toJSON() {
    return {
      'roles': roles.toString(),
      'uid': uid,
    };
  }

  factory ChatRoles.fromJSON(Map<String, dynamic> json) {
    return ChatRoles(
      roles: json['roles'] == 'Roles.admin'
          ? Roles.admin
          : json['roles'] == 'Roles.member'
              ? Roles.member
              : Roles.requester,
      uid: json['uid'],
    );
  }
}

class ChatModel {
  final int? created_at;
  final int? updated_at;
  final String id;
  final List<String>? members;
  final List<ChatRoles>? roles;
  final ChatSettings settings;

  String? joinCode;

  // One to One chats

  // Group chat
  @HiveField(4)
  final bool? isGroup;

  // Group chat
  String? groupName;
  final String? groupImage;
  final String? groupDescription;

  // * Utils for UI
  // * Not in the database
  List<ProfileModel>? users;
  String? name;

  ChatModel(
      {this.created_at,
      this.updated_at,
      required this.id,
      this.members,
      this.roles,
      this.joinCode,
      this.isGroup = false,
      this.groupImage,
      this.groupName,
      this.groupDescription,
      this.users,
      required this.settings,
      this.name});

  factory ChatModel.fromJSON(Map<String, dynamic> json) {
    return ChatModel(
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      id: json['id'],
      members: List<String>.from(json['members'] ?? []),
      isGroup: json['isGroup'],
      groupName: json['groupName'],
      groupDescription: json['groupDescription'],
      groupImage: json['groupImage'],
      joinCode: json['joinCode'],
      settings:
          ChatSettings.fromJSON(Map<String, dynamic>.from(json['settings'])),
      roles: List<ChatRoles>.from(json['roles']
              ?.map((e) => ChatRoles.fromJSON(Map<String, dynamic>.from(e))) ??
          []),
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
      'groupDescription': groupDescription,
      'joinCode': joinCode,
      'roles': roles?.map((e) => e.toJSON()).toList(),
      'settings': settings.toJSON(),
    };
  }

  Future<void> generateJoiningLink() async {
    joinCode = await customAlphabet('1234567890ABCDEFGHIJKLMNOPQRTUVWXYZ', 6);
  }

  Future<void> validateGroupName() async {
    if (groupName == null) {
      String uid = members!.firstWhere(
          (element) => element != FirebaseAuth.instance.currentUser?.uid);

      ProfileModel user = await UsersService().getProfileByID(uid);

      groupName = user.name;
    }
  }

  Future<void> loadUsers() async {
    users = [];

    for (int i = 0; i < (members?.length ?? 0); i++) {
      ProfileModel user = await UsersService().getProfileByID(members![i]);
      users!.add(user);
    }
  }
}
