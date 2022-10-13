part of 'users_cubit.dart';

class UserState {
  List<UserModel> users = [];
  List<FriendsList> friends = [];

  UserState({this.users = const [], this.friends = const []});

  void addUser(UserModel user) {
    users.add(user);
  }

  void removeUser(UserModel user) {
    users.remove(user);
  }
}
