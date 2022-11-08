import 'package:firebase_auth/firebase_auth.dart';
import 'package:udhaari/classes/profile.dart';

class AuthInitial {
  bool is_authenticated = false;
  String? user_id;
  ProfileModel? user;

  AuthInitial({this.is_authenticated = false, this.user_id, this.user});

  void copyWith({bool? is_authenticated, String? user_id}) {
    this.is_authenticated = is_authenticated ?? this.is_authenticated;
    this.user_id = user_id ?? this.user_id;
  }
}
