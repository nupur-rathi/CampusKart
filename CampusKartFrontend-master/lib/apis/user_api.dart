import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserProvider with ChangeNotifier {
  UserProvider() {
  }

  Map<dynamic, User> _users = {};

  Map<dynamic, User> get users {
    return {..._users};
  }

  // add user to databse on register using username
  void addUser(User User) async {
    // post request
    final response =
        await http.post(Uri.parse('http://${dotenv.env['URL']}/apis/v1/user/'),
            headers: {
              "Content-Type": "application/json",
            },
            body: json.encode(User));
    if (response.statusCode == 201) {
      User.username = json.decode(response.body)['username'];
      User.first_name = json.decode(response.body)['first_name'];
      User.last_name = json.decode(response.body)['last_name'];
      User.phone_number = json.decode(response.body)['phone_number'];
      User.emailId = json.decode(response.body)['emailId'];
      _users[User.username] = User;
      notifyListeners();
    }
  }

  // delete user from database
  void deleteUser(User User) async {
    final response = await http.delete(Uri.parse(
        'http://${dotenv.env['URL']}/apis/v1/user/${User.username}/'));
    if (response.statusCode == 204) {
      _users.remove(User.username);
      notifyListeners();
    }
  }

// update user information in database on edit profile
  void UpdateUser(User User) async {
    final response = await http.put(
        Uri.parse('http://${dotenv.env['URL']}/apis/v1/user/${User.username}/'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(User));
    if (response.statusCode == 200) {
      //parse OK code
      User.first_name = json.decode(response.body)['first_name'];
      User.last_name = json.decode(response.body)['last_name'];
      User.phone_number = json.decode(response.body)['phone_number'];
      notifyListeners();
    }
  }

// update users profile image inside database
  void updateProfileImage(String username, String image) async {
    var request = http.MultipartRequest("PUT",
        Uri.parse('http://${dotenv.env['URL']}/apis/v1/user/${username}/'));

    // print('${request.fields} image');

    Uint8List bytes = File(image).readAsBytesSync();

    var pic = http.MultipartFile.fromBytes('image', bytes, filename: image);


    var result = await request.send();

    var response = await http.Response.fromStream(result);



    if (result.statusCode == 201) {
      notifyListeners();
    }
  }

  Future<Map<dynamic, User>> fetchTasks() async {
    final url = 'http://${dotenv.env['URL']}/apis/v1/user/?format=json';
    final response = await http
        .get(Uri.parse(url), headers: {"Access-Control-Allow-Origin": "*"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<User> l = data.map<User>((json) => User.fromJson(json)).toList();
      _users = {for (var e in l) e.username: e};
      notifyListeners();
    }
    return {..._users};
  }
}
