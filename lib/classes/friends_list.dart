import 'dart:async';

import 'package:udhaari/classes/profile.dart';

class FriendsList {
  String? chat_id;
  ProfileModel? uid;
  int? created_at;
  int? updated_at;

  FriendsList({this.chat_id, this.uid, this.created_at, this.updated_at});

  factory FriendsList.fromJSON(Map<String, dynamic> json) {
    return FriendsList(
      chat_id: json['chat_id'],
      uid: ProfileModel().fromJSON(json['uid']),
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }

  fromJSON({chat_id, uid, created_at, updated_at}) {
    print(uid);
    FriendsList _user = FriendsList(
      chat_id: chat_id,
      uid: uid,
      created_at: created_at,
      updated_at: updated_at,
    );

    return _user;
  }
}
