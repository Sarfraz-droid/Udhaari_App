import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:udhaari/components/Layout/nav_appbar.dart';
import 'package:udhaari/components/UI/Cards/user_card.dart';
import 'package:udhaari/components/navbar.dart';
import 'package:permission_handler/permission_handler.dart';

class Friends extends HookWidget {
  const Friends({super.key});

  @override
  Widget build(BuildContext context) {
    return Navbar(
        title: 'Friends',
        appBar: NavAppBar(
          title: 'Friends',
          onSearchChange: (value) {
            print(value);
          },
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Search Here',
                          isDense: true,
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor:
                              ThemeData().primaryColorLight.withAlpha(50)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                      onPressed: () {}, child: const Text('+ Add Friend'))
                ],
              ),
              const Divider(
                height: 15,
                thickness: 1,
                endIndent: 0,
                color: Colors.black12,
              ),
            ],
          ),
        ));
  }
}
