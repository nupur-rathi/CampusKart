// test code
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/widgets/constant.dart';
import 'package:olx_iit_ropar/src/widgets/notification_appbar.dart';
import 'package:olx_iit_ropar/src/widgets/back_button.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: const DefaultAppBar(
        title: 'Notifications',
        child: DefaultBackButton(),
      ),
      body: FittedBox(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(kFixPadding),
          padding: const EdgeInsets.all(kFixPadding),
          decoration: BoxDecoration(
              color: kWhiteColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(color: kLightColor, blurRadius: 2.0)
              ]),
          child: Column(
            children: const [
              Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                  style: kDarkTextStyle),
              SizedBox(height: 16.0),
              SizedBox(height: 16.0),
              Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
                  style: TextStyle(color: kLightColor)),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: Text('11/Feb/2021 04:42 PM',
                    style: TextStyle(color: kLightColor)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
