import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat.dart';
import 'package:udhaari/classes/chat/chat_settings.dart';
import 'package:udhaari/classes/chat/chat_tags.dart';
import 'package:udhaari/services/hive/chat/settings.dart';
import 'package:udhaari/store/chats/chat.dart';

final settingsProvider = StateNotifierProvider((ref) {
  return SettingsPod(
    chatStore: ref.watch(chatProvider.notifier),
  );
});

class SettingsPod extends StateNotifier<ChatSettings> {
  ChatPod chatStore;

  SettingsPod({
    required this.chatStore,
  }) : super(ChatSettings());

  updateSettings(ChatSettings settings) {
    state = settings;
  }

  loadSettings() {
    state = HiveSettings(
      id: chatStore.state.currentChat!.id!,
    ).getSettings();
  }

  saveSettings() {
    HiveSettings(
      id: chatStore.state.currentChat!.id!,
    ).setSettings(settings: state.toJSON());
  }

  updateTags(List<ChatTags> tags) {
    state.tags = tags;
  }

  removeTag(int index) {
    print('Removing tag $index');
    state.tags.removeAt(index);
    state.tags = [...state.tags];
  }

  ChatTags getTag(String id) {
    return state.tags.firstWhere((element) => element.id == id);
  }
}
