// keeps the list of all the notifications in the app for a user
import 'dart:ffi';
import 'package:olx_iit_ropar/src/widgets/constant.dart';
import 'package:olx_iit_ropar/src/widgets/notification_tiles.dart';
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/screens/notification_screen.dart';
import 'package:olx_iit_ropar/src/widgets/back_button.dart';
import 'package:olx_iit_ropar/src/widgets/notification_appbar.dart';
import 'package:olx_iit_ropar/apis/notification_api.dart';
import 'package:olx_iit_ropar/models/notification.dart';
import 'package:provider/provider.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key}) : super(key: key);

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  void updateNotifications(NotificationProvider nf) async {
    for (MyNotification mn in nf.notifications.values) {
      if (mn.read == false) {
        mn.read = true;
        await nf.updateNotification(mn);
      }
    }
  }

  late NotificationProvider nf;

  @override
  void initState() {
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => updateNotifications(nf));
  }

  Map<dynamic, MyNotification> notifications = {};

  Future getNotifications() async {
    await nf.fetchTasks();
    setState(() {
      notifications = nf.notifications;
    });
  }

  @override
  Widget build(BuildContext context) {
    nf = Provider.of<NotificationProvider>(context, listen: false);
    getNotifications();

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: const DefaultAppBar(
        title: 'Notifications',
        child: DefaultBackButton(),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            getNotifications();
          },
          child: Stack(
            children: [
              ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    String key = notifications.keys
                        .elementAt(notifications.length - index - 1);
                    return NotificationTiles(
                      title: 'New product uploaded to CampusKart',
                      subtitle: notifications[key]!.description,
                      enable: true,
                      read: notifications[key]!.read,
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => NotificationScreen()));
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  }),
            ],
          )),
    );
  }
}
