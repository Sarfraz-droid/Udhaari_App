import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends HookWidget {
  const HomeAppBar({super.key});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar();
  }
}
