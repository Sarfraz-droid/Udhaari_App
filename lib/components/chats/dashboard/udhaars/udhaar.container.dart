import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:udhaari/components/chats/dashboard/udhaars/your_udhaars.dart';
import 'package:udhaari/services/hive/chat/dashboard.dart';

class UdhaarContainer extends StatelessWidget {
  String chatId;
  UdhaarContainer({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('chats_${chatId}').listenable(),
      builder: (context, value, child) {
        print("UdhaarContainer: ValueListenableBuilder called");
        final udhaar = HiveDashboard(id: chatId).getDashboard().udhaar;
        return YourUdhaars(
          udhaari: udhaar,
        );
      },
    );
  }
}
