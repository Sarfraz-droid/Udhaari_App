import 'package:firebase_auth/firebase_auth.dart';
import 'package:udhaari/classes/user_friends.dart';

class UserModel {
  List<Object>? chats;
  List<UserFriends>? friends;
  int? created_at;
  int? updated_at;

  UserModel({this.chats, this.friends, this.created_at, this.updated_at});

  fromJSON(Map<String, dynamic> map) {
    print(map['friends']);
    UserModel _user = UserModel(
      chats: List<Object>.from(['chats']),
      friends: List<UserFriends>.from(
        map['friends'].map((x) => UserFriends().fromJSON(x)),
      ),
      created_at: map['created_at'],
      updated_at: map['updated_at'],
    );

    return _user;
  }

  factory UserModel.fromJSON(Map<String, dynamic> map) {
    print(map['friends']);
    UserModel _user = UserModel(
      chats: List<Object>.from(['chats']),
      friends: List<UserFriends>.from(
        map['friends'].map((x) => UserFriends().fromJSON(x)),
      ),
      created_at: map['created_at'],
      updated_at: map['updated_at'],
    );

    return _user;
  }
}
