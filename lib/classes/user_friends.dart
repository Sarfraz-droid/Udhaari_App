import 'package:firebase_auth/firebase_auth.dart';

class UserFriends {
  String? chat_id;
  String? uid;
  int? created_at;
  int? updated_at;

  UserFriends({this.chat_id, this.uid, this.created_at, this.updated_at});

  fromJSON(Map<String, dynamic> map) {
    UserFriends _user = UserFriends(
      chat_id: map['chat_id'],
      uid: map['uid'],
      created_at: map['created_at'],
      updated_at: map['updated_at'],
    );

    return _user;
  }
}
