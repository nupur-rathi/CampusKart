// Tile for a single notification
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/widgets/constant.dart';

class NotificationTiles extends StatelessWidget {
  final String title, subtitle;
  final Function onTap;
  final bool enable;
  final bool read;
  const NotificationTiles({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.enable,
    required this.read,
  }) : super(key: key);

  final Color c = const Color(0x00000000);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: kDarkColor)),
      subtitle: Text(subtitle, style: const TextStyle(color: kLightColor)),
      onTap: null,
      enabled: enable,
      tileColor: read ? Colors.white : const Color.fromARGB(255, 238, 249, 243),
      // selectedTileColor: ,
      trailing: read
          ? null
          : const Icon(
              Icons.circle,
              color: Colors.black,
              size: 10,
            ),
    );
  }
}
