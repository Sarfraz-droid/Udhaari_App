import 'package:udhaari/classes/chat/chat_tags.dart';
import 'package:udhaari/classes/chat/chat_udhaar.dart';
import 'package:udhaari/config/Chat/defaultTags.dart';

class ChatDashboard {
  Map<String, ChatUdhaar> udhaar = new Map<String, ChatUdhaar>();
  double total = 0;

  ChatDashboard({required this.udhaar, this.total = 0}) {}

  factory ChatDashboard.fromJSON(Map<String, dynamic> json) {
    Map<String, ChatUdhaar> udhaar = new Map<String, ChatUdhaar>();

    for (String uid in json['udhaar'].keys) {
      udhaar['$uid'] = ChatUdhaar.fromJSON(
          Map<String, dynamic>.from(json['udhaar']['$uid']));
    }

    return ChatDashboard(
      udhaar: json['udhaar'] != null ? udhaar : {},
      total: json['total'] != null ? double.parse(json['total'].toString()) : 0,
    );
  }

  toJSON() {
    Map<String, dynamic> udhaarMap = new Map<String, dynamic>();

    udhaar.forEach((key, value) {
      udhaarMap[key] = value.toJSON();
    });

    return {
      "udhaar": udhaarMap,
      "total": total,
    };
  }
}
