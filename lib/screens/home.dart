import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:udhaari/classes/chat/chat_list.dart';
import 'package:udhaari/components/Layout/appbar/actions.dart';
import 'package:udhaari/components/Layout/nav_appbar.dart';
import 'package:udhaari/components/home/AppBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:udhaari/services/chats.dart';
import 'package:udhaari/services/users.dart';
import 'package:udhaari/store/counter/counter_cubit.dart';

import '../components/navbar.dart';

class Home extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final user = useState<User?>(null);
    useEffect(() {
      user.value = FirebaseAuth.instance.currentUser;

      return () {};
    }, [FirebaseAuth.instance.currentUser]);

    Future<List<ChatList>> _getChats() async {
      print("Getting chats");
      final chats = await FirebaseUsers().getChatList();
      return chats;
    }

    return Navbar(
        title: "Home",
        appBar: NavAppBar(
          title: "Dashboard",
          onSearchChange: (value) {
            print(value);
          },
        ),
        floatingAction: FloatingActionButton(
          onPressed: () {
            GoRouter.of(context).push('/add_expense');
          },
          child: const Icon(Icons.add),
        ),
        child: FutureBuilder(
          future: _getChats(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          snapshot.data![index].chat?.groupName ?? "Unkown"),
                      leading: CircleAvatar(
                          child: Text(snapshot.data![index].chat?.groupName
                                  .toString()
                                  .substring(0, 1) ??
                              "U")),
                      subtitle: Text(
                          snapshot.data![index].lastMessage?.getMessage() ??
                              "Tap to start a conversation"),
                      onTap: () {
                        GoRouter.of(context)
                            .push('/chat/${snapshot.data![index].chat?.id}');
                      },
                    );
                  },
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
