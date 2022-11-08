import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddGroupHome extends StatelessWidget {
  Function onChange;
  AddGroupHome({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Have a group code?'),
          TextButton(
              onPressed: () {
                onChange(2);
              },
              child: const Text('Join a group with a code')),
          const SizedBox(height: 20),
          const Text('Or'),
          const SizedBox(height: 20),
          const Text('Create a new group'),
          TextButton(
              onPressed: () {
                onChange(1);
              },
              child: const Text('Create a new group')),
        ],
      ),
    );
  }
}
