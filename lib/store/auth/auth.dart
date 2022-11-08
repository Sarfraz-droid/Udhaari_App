import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/screens/profile.dart';
import 'package:udhaari/services/users.dart';
import 'package:udhaari/store/auth/auth_state.dart';

final authProvider = StateNotifierProvider((ref) {
  return AuthPod();
});

class AuthPod extends StateNotifier<AuthInitial> {
  AuthPod() : super(AuthInitial());

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
      print("Registering");
      await UsersService().register(email, password, name);
      print("User created");
    } catch (e) {
      print('Error Occurred on _register $e');
      throw e;
    }
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> update(User? user) async {
    if (user == null) {
      state = AuthInitial();
    } else {

      ProfileModel profileModel = await UsersService().getProfileByID(user.uid);
      state = AuthInitial(
        is_authenticated: true,
        user_id: user.uid,
        user: profileModel,
      );
    }
    ;
  }

  void updateToken(String token) {
    UsersService().updateToken(token);
  }
}
