import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udhaari/components/UI/showDialog.dart';
import 'package:udhaari/store/auth/cubit/auth_cubit.dart';

class AuthPage extends StatefulWidget {
  final String title;
  final bool isLogin;

  const AuthPage({super.key, required this.title, this.isLogin = true});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String _email = "";
  String _password = "";
  String _confirmPassword = "";
  String _name = "";
  bool _isProcessing = false;

  void onHandleChange(String value, String type) {
    switch (type) {
      case "email":
        setState(() {
          _email = value;
        });
        break;
      case "password":
        setState(() {
          _password = value;
        });
        break;
      case "confirmPassword":
        setState(() {
          _confirmPassword = value;
        });
        break;
      case "name":
        setState(() {
          _name = value;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser);
    final _authState = context.read<AuthCubit>();

    Future<void> onSubmit() async {
      if (_email.isEmpty || _password.isEmpty) {
        ShowDialog.show(
          content: "Please fill all the fields",
          context: context,
          title: "Error",
        );
        return;
      }
      setState(() {
        _isProcessing = true;
      });
      if (widget.isLogin) {
        print("Login");
        try {
          await _authState.login(_email, _password);
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
        if (_password != _confirmPassword || _email.isEmpty || _name.isEmpty) {
          ShowDialog.show(
            content: "Please Check your input",
            context: context,
            title: "Error",
          );
        } else {
          try {
            print("Registering user");
            await _authState.register(_email, _password, _name);
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
      context.go('/');
      setState(() {
        _isProcessing = false;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(widget.title,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w300)),
              ),
              Visibility(
                visible: !widget.isLogin,
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
                visible: !widget.isLogin,
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
                  child: Text(!widget.isLogin
                      ? _isProcessing
                          ? "Registering"
                          : "Register"
                      : _isProcessing
                          ? "Logging in"
                          : "Login"),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.isLogin
                      ? "Don't have an account?"
                      : "Already have an account?"),
                  TextButton(
                    onPressed: () {
                      context.go(
                        widget.isLogin ? '/auth/register' : '/auth/login',
                      );
                    },
                    child: Text(widget.isLogin ? "Register" : "Login"),
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
