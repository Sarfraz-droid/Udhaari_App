import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/friends_list.dart';
import 'package:udhaari/classes/user.dart';
import 'package:udhaari/services/friends.dart';
import 'package:udhaari/store/users/users_state.dart';

final usersProvider = StateNotifierProvider((ref) {
  return UsersPod();
});

class UsersPod extends StateNotifier<UserState> {
  UsersPod() : super(UserState());

  void addUser(UserModel user) {
    state.addUser(user);
  }

  void removeUser(UserModel user) {
    state.removeUser(user);
  }

  Future<void> loadFriends() async {
    List<FriendsList?> _friends = await FriendsService().getFriends();

    state.friends = _friends as List<FriendsList>;
  }
}
