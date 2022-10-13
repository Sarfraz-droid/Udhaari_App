import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';

class NavBackButton extends StatelessWidget {
  final bool isVisible;
  final Function onPressed;
  const NavBackButton(
      {super.key, required this.isVisible, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: IconButton(
        onPressed: () {
          onPressed();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}
