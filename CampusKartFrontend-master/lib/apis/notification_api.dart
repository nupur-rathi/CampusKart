import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/main.dart';
import '../models/notification.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotificationProvider with ChangeNotifier {
  NotificationProvider() {
    // fetchTasks();
  }

  // ignore: non_constant_identifier_names
  Map<dynamic, MyNotification> _notifications = {};

  Map<dynamic, MyNotification> get notifications {
    return {..._notifications};
  }

  // add notifications to database
  void addNotification(MyNotification Notification) async {
    final response = await http.post(
        Uri.parse('http://${dotenv.env['URL']}/apis/v1/shownotification/'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(Notification));
    if (response.statusCode == 201) {
      Notification.username = json.decode(response.body)['username'];
      Notification.id = json.decode(response.body)['id'];
      Notification.description = json.decode(response.body)['description'];
      Notification.read = json.decode(response.body)['read'];
      _notifications[Notification.id] = Notification;
      unread_notification_count.value++;
      notifyListeners();
    }
  }

  // update notification to database
  Future<MyNotification?> updateNotification(MyNotification notif) async {
    final response = await http.put(
        Uri.parse(
            'http://${dotenv.env['URL']}/apis/v1/shownotification/${notif.id}/'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(notif));
    if (response.statusCode == 200) {
      //parse OK code
      notif.id = json.decode(response.body)['id'];
      notif.description = json.decode(response.body)['description'];
      notif.username = json.decode(response.body)['username'];
      notif.read = json.decode(response.body)['read'];
      unread_notification_count.value--;
      return notif;
      notifyListeners();
    }
    return null;
  }

  // delete notification from database
  void deleteNotification(String id) async {
    final response = await http.delete(Uri.parse(
        'http://${dotenv.env['URL']}/apis/v1/shownotification/${id}/'));
    if (response.statusCode == 204) {
      _notifications.remove(id);
      // notifyListeners();
    }
  }

  // fetch notifications from database
  Future fetchTasks() async {
    final url =
        'http://${dotenv.env['URL']}/apis/v1/shownotification/?format=json';
    final response = await http
        .get(Uri.parse(url), headers: {"Access-Control-Allow-Origin": "*"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<MyNotification> l = data
          .map<MyNotification>((json) => MyNotification.fromJson(json))
          .toList();

      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      var username = user?.email!.substring(0, user.email!.length - 13);

      var num_unread_notif = 0;

      for (var e in l) {
        if (e.username.compareTo(username.toString()) == 0) {
          _notifications[e.id] = e;
          if (e.username.compareTo(username!) == 0 && e.read == false) {
            num_unread_notif++;
          }
        }
      }

      unread_notification_count.value = num_unread_notif;

      notifyListeners();
    }
  }
}