import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat_dashboard.dart';
import 'package:udhaari/classes/chat/chat_tags.dart';
import 'package:udhaari/services/hive/chat/dashboard.dart';
import 'package:udhaari/store/chats/chat.dart';

final dashboardProvider = StateNotifierProvider((ref) {
  return DashboardPod(
    chatStore: ref.watch(chatProvider.notifier),
  );
});

class DashboardPod extends StateNotifier<ChatDashboard> {
  ChatPod chatStore;
  DashboardPod({
    required this.chatStore,
  }) : super(ChatDashboard(udhaar: {}));

  updateDashboard(ChatDashboard dashboard) {
    state = dashboard;
  }

  saveDashboard() {
    HiveDashboard(
      id: chatStore.state.currentChat!.id!,
    ).saveDashboard(dashboard: state);
  }

  loadDashboard() {
    state = HiveDashboard(
      id: chatStore.state.currentChat!.id!,
    ).getDashboard();
  }


}
