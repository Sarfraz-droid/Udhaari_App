part of 'auth_cubit.dart';

class AuthInitial {
  bool is_authenticated = false;
  String? user_id;

  AuthInitial({this.is_authenticated = false, this.user_id});

  void copyWith({bool? is_authenticated, String? user_id}) {
    this.is_authenticated = is_authenticated ?? this.is_authenticated;
    this.user_id = user_id ?? this.user_id;
  }
}
