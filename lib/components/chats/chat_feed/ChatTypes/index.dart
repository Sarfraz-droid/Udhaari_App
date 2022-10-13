import 'package:flutter/cupertino.dart';
import 'package:udhaari/classes/chat.dart';

import 'expense_type.dart';
import 'message_type.dart';

Map<String, Widget Function({required ChatMessage message})> chatTypes = {
  "message": ({required message}) => MessageType(message: message),
  "expense": ({required message}) => ExpenseType(message: message),
};
