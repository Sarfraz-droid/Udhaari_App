import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppBarActions extends HookWidget {
  final Function onSearch;
  final bool is_search;
  const AppBarActions(
      {super.key, required this.onSearch, required this.is_search});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!is_search)
          IconButton(
              onPressed: () {
                onSearch();
              },
              icon: const Icon(Icons.search)),
      ],
    );
  }
}
