import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:olx_iit_ropar/models/user_image.dart';

class UserImageProvider with ChangeNotifier {
  // ignore: non_constant_identifier_names
  Map<dynamic, UserImage> _userImages = {};

  // ignore: non_constant_identifier_names
  Map<dynamic, UserImage> get userImages {
    return {..._userImages};
  }

  UserImage? l;

// api to add userimage to database
  Future<bool> addUserImage(UserImage UserImage) async {
    deleteUserImage(UserImage);

    var request = http.MultipartRequest(
        "POST", Uri.parse('http://${dotenv.env['URL']}/apis/v1/userimage/'));


    Uint8List bytes = File(UserImage.image).readAsBytesSync();

    var pic =
        http.MultipartFile.fromBytes('image', bytes, filename: UserImage.image);

    request.fields['username'] = UserImage.username.toString();
    request.files.add(pic);

    var result = await request.send();
    var response = await http.Response.fromStream(result);


    if (result.statusCode == 201) {
      UserImage.image = json.decode(response.body)["image"];
      UserImage.username = json.decode(response.body)["username"];
      l = UserImage;
      _userImages[UserImage.username] = UserImage;
      notifyListeners();
      return true;
    }
    return false;
  }

//api to delete user image from database using username
  void deleteUserImage(UserImage userImage) async {
    final response = await http.delete(Uri.parse(
        'http://${dotenv.env['URL']}/apis/v1/userimage/${userImage.username}/'));
    if (response.statusCode == 204) {
      l = UserImage(
          username: userImage.username,
          image:
              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png");
      _userImages.remove(userImage.username);
      notifyListeners();
    }
  }

  // fetch user image api
  fetchUserImage(String username) async {
    final url = 'http://${dotenv.env['URL']}/apis/v1/userimage/${username}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      l = UserImage.fromJson(data);
      notifyListeners();
    }
  }
}
