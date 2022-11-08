import 'package:flutter/material.dart';
import 'package:udhaari/classes/chat/chat_tags.dart';
import 'package:uuid/uuid.dart';

final defaultTags = [
  ChatTags(
      color: Colors.black, name: 'Books', icon: Icons.book, id: Uuid().v4()),
  ChatTags(
      color: Colors.orange,
      name: 'Food',
      icon: Icons.fastfood,
      id: Uuid().v4()),
  ChatTags(
      color: Colors.blue, name: 'Travel', icon: Icons.flight, id: Uuid().v4()),
  ChatTags(
      color: Colors.green,
      name: 'Shopping',
      icon: Icons.shopping_cart,
      id: Uuid().v4()),
  ChatTags(
      color: Colors.red, name: 'Bills', icon: Icons.receipt, id: Uuid().v4()),
  ChatTags(
      color: Colors.purple, name: 'Rent', icon: Icons.home, id: Uuid().v4()),
  ChatTags(
      color: Colors.yellow[700]!,
      name: 'Misc',
      icon: Icons.more_horiz,
      id: Uuid().v4()),
];
