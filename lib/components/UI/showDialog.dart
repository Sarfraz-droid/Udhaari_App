import 'package:flutter/material.dart';

void _showDialog({title, content, context}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"))
          ],
        );
      });
}

class ShowDialog {
  final navigatorKey = new GlobalKey<NavigatorState>();

  static void show({title, content, context}) {
    _showDialog(title: title, content: content, context: context);
  }

  static void success({content, context}) {
    _showDialog(title: "Success", content: content, context: context);
  }

  static void error({content, context}) {
    _showDialog(title: "Error", content: content, context: context);
  }
}
