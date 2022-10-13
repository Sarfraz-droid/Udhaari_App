import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:udhaari/classes/friends_list.dart';
import 'package:udhaari/classes/user.dart';
import 'package:udhaari/services/friends.dart';
import 'package:udhaari/services/users.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UserState> {
  UsersCubit() : super(UserState());

  void addUser(UserModel user) {
    state.addUser(user);
  }

  void removeUser(UserModel user) {
    state.removeUser(user);
  }

  Future<void> loadFriends() async {
    List<FriendsList?> _friends = await FirebaseFriends().getFriends();

    state.friends = _friends as List<FriendsList>;
  }
}
