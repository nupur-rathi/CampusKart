import 'dart:ffi';
// MyNotification Model corresponding to notifications table in our database
class MyNotification {
  String? id;
  String username;
  String description;
  bool read;

  MyNotification(
      {this.id,
      required this.username,
      required this.description,
      required this.read});

  factory MyNotification.fromJson(Map<String, dynamic> json) {
    return MyNotification(
      username: json['username'],
      id: json['id'],
      description: json['description'],
      read: json['read'],
    );
  }

  dynamic toJson() => {
        'username': username,
        'id': id,
        'description': description,
        'read': read
      };
}
