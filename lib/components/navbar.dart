import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavItem {
  final String title;
  final String path;
  final IconData icon;
  final IconData? activeIcon;
  NavItem(
      {required this.title,
      required this.path,
      required this.icon,
      this.activeIcon});
}

class Navbar extends HookWidget {
  final String title;
  final Widget? child;
  final Widget? floatingAction;
  final PreferredSizeWidget? appBar;
  final bool showBottomNav;
  final navList = [
    NavItem(title: 'Home', path: '/', icon: Icons.home),
    // NavItem(title: 'Friends', path: '/friends', icon: Icons.people),
    NavItem(title: 'Profile', path: '/profile', icon: Icons.person),
  ];

  Navbar({
    super.key,
    required this.title,
    this.child,
    this.floatingAction,
    this.appBar,
    this.showBottomNav = true,
  });

  @override
  Widget build(BuildContext context) {
    int findIndex() {
      for (var i = 0; i < navList.length; i++) {
        if (navList[i].path == GoRouter.of(context).location) {
          return i;
        }
      }
      return 0;
    }

    final currentRoute = useState(findIndex());

    void onItemTapped(int index) {
      currentRoute.value = index;
      context.go(navList[index].path);
    }

    return Scaffold(
        appBar: appBar,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Visibility(
            visible: showBottomNav,
            child: bottomNavBar(onItemTapped, currentRoute)),
        floatingActionButton: floatingAction,
        body: SafeArea(
          child: child!,
        ));
  }

  Widget bottomNavBar(
      void Function(int index) onItemTapped, ValueNotifier<int> currentRoute) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            for (var item in navList)
              BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.title,
              )
          ],
          backgroundColor: ThemeData.light().primaryColor.withAlpha(220),
          elevation: 16.0,
          onTap: (value) => onItemTapped(value),
          currentIndex: currentRoute.value,
          selectedItemColor: Colors.white,
          unselectedItemColor: ThemeData.light().primaryColorDark,
          selectedFontSize: 12,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
