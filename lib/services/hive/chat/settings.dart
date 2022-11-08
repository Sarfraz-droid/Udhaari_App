import 'package:hive_flutter/hive_flutter.dart';
import 'package:udhaari/classes/chat/chat_settings.dart';

class HiveSettings {
  String id;
  late Box<dynamic> settingsBox;

  HiveSettings({required this.id}) {
    settingsBox = Hive.box('chats_${id}');
  }

  getId() {
    return id;
  }

  ChatSettings getSettings() {
    Map<String, dynamic> settings;
    if (!settingsBox.containsKey('settings')) {
      setupSettings();
    }
    settings = Map<String, dynamic>.from(settingsBox.get('settings'));

    return ChatSettings.fromJSON(settings);
  }

  setSettings({required Map<String, dynamic> settings}) {
    settingsBox.put('settings', settings);
  }

  setupSettings() {
    ChatSettings settings = ChatSettings();

    setSettings(settings: settings.toJSON());
  }

  static Future<void> updateSettings(
      {required String chatId, required ChatSettings settings}) async {
    await Hive.openBox('chats_${chatId}');

    final hiveBox = Hive.box('chats_${chatId}');

    hiveBox.put('settings', settings.toJSON());
  }
}
