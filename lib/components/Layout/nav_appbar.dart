import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:udhaari/components/Layout/appbar/actions.dart';
import 'package:udhaari/components/Layout/appbar/back_button.dart';
import 'package:udhaari/hooks/debouncer.dart';

class NavAppBar extends HookWidget with PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final Function onSearchChange;
  const NavAppBar(
      {super.key,
      required this.onSearchChange,
      required this.title,
      this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 500);
    final is_search = useState(false);
    final search_text = useState("");

    useEffect(() {
      _debouncer.run(() {
        onSearchChange(search_text.value);
      });
    }, [search_text.value]);

    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10),
        ),
      ),
      leadingWidth: 20.0,
      title: is_search.value
          ? TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              onChanged: (value) {
                _debouncer.run(() {
                  // search here
                  search_text.value = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
            )
          : Text(title!),
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: NavBackButton(
        isVisible: showBackButton || is_search.value,
        onPressed: () {
          if (is_search.value) {
            is_search.value = false;
          } else {
            GoRouter.of(context).pop();
          }
        },
      ),
      actions: [
        AppBarActions(
          onSearch: () {
            is_search.value = !is_search.value;
          },
          is_search: is_search.value,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
