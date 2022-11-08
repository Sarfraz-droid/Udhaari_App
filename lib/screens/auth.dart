import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/components/UI/showDialog.dart';
import 'package:udhaari/store/auth/auth.dart';

class AuthPage extends HookConsumerWidget {
  final String title;
  final bool isLogin;


  AuthPage({super.key, required this.title, this.isLogin = true});
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final _email = useState('');
    final _password = useState('');
    final _confirmPassword = useState('');
    final _name = useState('');
    final _isProcessing = useState(false);
    final _authState = ref.watch(authProvider.notifier);

    void onHandleChange(String value, String type) {
      switch (type) {
        case "email":
          _email.value = value;
          break;
        case "password":
          _password.value = value;
          break;
        case "confirmPassword":
          _confirmPassword.value = value;
          break;
        case "name":
          _name.value = value;
          break;
      }
    }




    Future<void> onSubmit() async {
      print("isLogin : $isLogin");
      if (_email.value.isEmpty || _password.value.isEmpty) {
        ShowDialog.show(
          content: "Please fill all the fields",
          context: context,
          title: "Error",
        );
        return;
      }
      _isProcessing.value = true;

      if (isLogin) {
        print("Login");
        try {
          await _authState.login(_email.value, _password.value);
        } on FirebaseAuthException catch (e) {
          print(e);
          if (e.code == "user-not-found") {
            ShowDialog.show(
              content: "No user found for that email.",
              context: context,
              title: "Error",
            );
          } else if (e.code == "wrong-password") {
            ShowDialog.show(
              content: "Wrong password provided for that user.",
              context: context,
              title: "Error",
            );
          } else {
            ShowDialog.show(
              content: e.message,
              context: context,
              title: "Error",
            );
          }
        } catch (e) {
          print('Error $e');
          ShowDialog.show(
            content: "Something went wrong",
            context: context,
            title: "Error",
          );
        }
      } else {
        print("Signup");
        if (_password.value != _confirmPassword.value ||
            _email.value.isEmpty ||
            _name.value.isEmpty) {
          print(
              "${_email.value} ${_password.value} ${_confirmPassword.value} ${_name.value}");
          ShowDialog.show(
            content: "Please Check your input",
            context: context,
            title: "Error",
          );
        } else {

          
          try {
            print("Registering user");
            await _authState.register(
                _email.value, _password.value, _name.value);
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {


              print('The password provided is too weak.');
            } else if (e.code == 'email-already-in-use') {
              ShowDialog.show(
                content: "The account already exists for that email.",
                context: context,
                title: "Error",
              );
            } else {
              ShowDialog.show(
                content: e.message,
                context: context,
                title: "Error",
              );
            }
          } catch (e) {
            print(e);
          }
        }
      }
      if (FirebaseAuth.instance.currentUser != null) {
        context.go('/');
      }
      _isProcessing.value = false;
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w300)),
              ),
              Visibility(
                visible: !isLogin,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    onChanged: (value) => onHandleChange(value, "name"),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  onChanged: (value) => onHandleChange(value, "email"),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextField(
                  onChanged: (value) => onHandleChange(value, "password"),
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              Visibility(
                visible: !isLogin,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    onChanged: (value) =>
                        onHandleChange(value, "confirmPassword"),
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: onSubmit,
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(50), // NEW
                  ),
                  child: Text(!isLogin
                      ? _isProcessing.value
                          ? "Registering"
                          : "Register"
                      : _isProcessing.value
                          ? "Logging in"
                          : "Login"),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isLogin
                      ? "Don't have an account?"
                      : "Already have an account?"),
                  TextButton(
                    onPressed: () {
                      context.go(
                        isLogin ? '/auth/register' : '/auth/login',
                      );
                    },
                    child: Text(isLogin ? "Register" : "Login"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
