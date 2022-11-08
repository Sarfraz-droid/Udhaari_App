import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChatTags {
  final Color color;
  final String name;
  final IconData icon;
  String id;
  final uuid = Uuid();

  ChatTags({
    required this.color,
    required this.name,
    required this.icon,
    required this.id,
  }) {
    // if (id != null) id = uuid.v4();
  }

  factory ChatTags.fromJSON(Map<String, dynamic> json) {
    return ChatTags(
      id: json['id'],
      color: Color(json['color']),
      name: json['name'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
    );
  }

  toJSON() {
    return {
      'id': id,
      'color': color.value,
      'name': name,
      'icon': icon.codePoint,
    };
  }
}
