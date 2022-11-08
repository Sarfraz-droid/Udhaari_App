import 'package:udhaari/classes/chat/chat_tags.dart';
import 'package:udhaari/config/Chat/defaultTags.dart';

class ChatSettings {
  List<ChatTags> tags = [];

  ChatSettings({this.tags = const []}) {
    if (tags.isEmpty) {
      tags = defaultTags;
    }
  }

  factory ChatSettings.fromJSON(Map<String, dynamic> json) {
    return ChatSettings(
        tags: json['tags'] != null
            ? List<ChatTags>.from(json['tags']
                .map((e) => ChatTags.fromJSON(Map<String, dynamic>.from(e))))
            : []);
  }

  toJSON() {
    return {
      "tags": List.from(tags.map((e) => e.toJSON())),
    };
  }
}
