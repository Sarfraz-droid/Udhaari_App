import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:udhaari/components/Layout/appbar/back_button.dart';
import 'package:udhaari/components/Layout/nav_appbar.dart';
import 'package:udhaari/components/chats/Action/add_announcment.dart';
import 'package:udhaari/components/chats/Action/add_expense.dart';
import 'package:udhaari/components/chats/Action/Expense/addExpenseModal.dart';
import 'package:udhaari/components/navbar.dart';

class AddActionContainer extends StatelessWidget {
  final String id;
  const AddActionContainer({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Navbar(
            title: "Add Action",
            showBottomNav: false,
            appBar: AppBar(
              title: const Text('Add Action'),
              leading: NavBackButton(
                isVisible: true,
                onPressed: () {
                  GoRouter.of(context).pop();
                },
              ),
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.payment), text: "Expense"),
                  Tab(icon: Icon(Icons.campaign), text: "Announcement"),
                ],
              ),
            ),
            child: TabBarView(
              children: [
                AddExpenseContainer(),
                AddAnnouncementContainer(),
              ],
            )),
      ),
    );
  }
}
