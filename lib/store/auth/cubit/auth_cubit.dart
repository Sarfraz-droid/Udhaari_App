import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:udhaari/services/users.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthInitial> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password) async {
    try {
      UserCredential credentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      await FirebaseUsers().register(
        email,
        password,
        name
      );
      print("User created");
    } catch (e) {
      print('Error Occurred on _register $e');
      throw e;
    }
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  void update(User? user) {
    if (user == null) {
      state.copyWith(
        is_authenticated: false,
        user_id: null,
      );
    } else {
      state.copyWith(
        is_authenticated: true,
        user_id: user.uid,
      );
    }
  }
}
