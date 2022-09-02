// App bar for the notifications
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/widgets/constant.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget child;
  final action;
  const DefaultAppBar({
    Key? key,
    required this.title,
    required this.child,
    this.action,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      elevation: kRadius,
      automaticallyImplyLeading: false,
      iconTheme: const IconThemeData(color: kPrimaryColor),
      leading: child,
    );
  }
}
