import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:udhaari/components/Layout/nav_appbar.dart';
import 'package:udhaari/components/UI/Cards/user_card.dart';
import 'package:udhaari/components/UI/showDialog.dart';
import 'package:udhaari/components/navbar.dart';
import 'package:udhaari/classes/profile.dart';
import 'package:udhaari/services/friends.dart';
import 'package:udhaari/services/users.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddFriend extends HookWidget {
  const AddFriend({super.key});

  @override
  Widget build(BuildContext context) {
    final _usersFound = useState<List<ProfileModel?>>([]);

    void _onSearchChange(String value) async {
      List<ProfileModel?> users = await FirebaseUsers().findUsers(email: value);
      _usersFound.value = users;
      print(users);
    }

    return Navbar(
      title: "Add Friend",
      appBar: NavAppBar(
        title: "Add Friend",
        showBackButton: true,
        onSearchChange: (value) {
          if (value.length > 3) _onSearchChange(value);
        },
      ),
      showBottomNav: false,
      child: Container(
        child: ListView.builder(
          itemCount: _usersFound.value.length,
          itemBuilder: ((context, index) {
            ProfileModel user = _usersFound.value[index]!;

            return Visibility(
              visible: user.email != FirebaseAuth.instance.currentUser!.email,
              child: UserCard(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Add Friend"),
                      content: Text(
                          "Are you sure you want to add ${user.name}(${user.email}) as a friend?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (user.uid != null) {
                              await FirebaseFriends().addFriend(user.uid!);
                              GoRouter.of(context).pop();
                              // Fluttertoast.showToast(
                              //     msg: "Friend Added Successfully");
                            }
                          },
                          child: Text("Add"),
                        ),
                      ],
                    ),
                  );
                },
                name: user.name ?? "Unknown",
                description: user.email ?? "Unknown",
                imageUrl: user.photo != null ? user.photo! : null,
                icon: Icons.person_add,
              ),
            );
          }),
        ),
      ),
    );
  }
}
