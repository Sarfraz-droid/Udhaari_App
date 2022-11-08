import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:udhaari/classes/chat/chat_tags.dart';
import 'package:udhaari/services/hive/chat/dashboard.dart';
import 'package:udhaari/store/chats/chat.dart';
import 'package:udhaari/store/dashboard/dashboard.dart';
import 'package:udhaari/store/settings/settings.dart';

class TagsContainer extends HookConsumerWidget {
  const TagsContainer({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _chat = ref.watch(chatProvider.notifier);
    final tagList = useState<List<ChatTags>>([]);

    useEffect(() {
      tagList.value = _chat.state.currentChat!.settings.tags;
    }, []);

    useEffect(() {
      _chat.state.currentChat!.settings.tags = tagList.value;
    }, [tagList.value]);

    return SafeArea(
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: () {},
        // ),
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 30.0),
              Text(
                'Tags',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: tagList.value.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${tagList.value[index].name}'),
                    leading: Icon(
                      tagList.value[index].icon,
                      color: tagList.value[index].color,
                    ),
                    // trailing: IconButton(
                    //   icon: Icon(Icons.close),
                    //   onPressed: () {
                    //     tagList.value.removeAt(index);
                    //     tagList.value = [...tagList.value];
                    //     // _chat.removeTag(dashboardState.value.tags[index].id!);
                    //     // dashboardState.value = HiveDashboard(
                    //     //         id: _chat.state.currentChat!.id!)
                    //     //     .getDashboard();
                    //   },
                    // ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
