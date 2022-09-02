import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

//picture provider to provide a single state management unit for pictures on frontend side with various apis to connect with backend
class PictureProvider with ChangeNotifier {
  PictureProvider() {}

  // Will store the category id
  int c_id = 0;

  void updateCID(input) {
    c_id = input;
    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  Map<dynamic, Picture> _pictures = {};

  // ignore: non_constant_identifier_names
  Map<dynamic, Picture> get pictures {
    return {..._pictures};
  }

  Map<dynamic, Picture> _recent_products_pictures = {};

  // ignore: non_constant_identifier_names
  Map<dynamic, Picture> get recentProductPictures {
    return {..._recent_products_pictures};
  }

  List<Picture> _product_pictures = [];

  // ignore: non_constant_identifier_names
  List<Picture> get productPictures {
    return [..._product_pictures];
  }

  Map<dynamic, List<Picture>> _map_of_pictures = {};

  // ignore: non_constant_identifier_names
  Map<dynamic, List<Picture>> get mapPictures {
    return {..._map_of_pictures};
  }

  // To add a new picture to the database
  Future<bool> addPicture(Picture Picture) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse('http://${dotenv.env['URL']}/apis/v1/image/'));

    Uint8List bytes = File(Picture.image).readAsBytesSync();

    var pic =
        http.MultipartFile.fromBytes('image', bytes, filename: Picture.image);

    request.fields['product_id'] = Picture.product_id;
    request.fields['category_id'] = Picture.category_id.toString();
    request.files.add(pic);

    var result = await request.send();
    var response = await http.Response.fromStream(result);

    if (result.statusCode == 201) {
      Picture.id = json.decode(response.body)["id"];
      Picture.image = json.decode(response.body)["image"];
      Picture.product_id = json.decode(response.body)['product_id'];
      Picture.category_id = json.decode(response.body)['category_id'];
      _pictures[Picture.id] = Picture;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Delete the picture from database based on a particular id
  void deletePicture(Picture Picture) async {
    final response = await http.delete(
        Uri.parse('http://${dotenv.env['URL']}/apis/v1/image/${Picture.id}/'));
    if (response.statusCode == 204) {
      _pictures.remove(Picture.id);
      notifyListeners();
    }
  }

  // Fetch the images based on the product
  fetchProductImages(pId) async {
    final url = 'http://${dotenv.env['URL']}/apis/v1/image/?product_id=' +
        pId.toString();
    final response = await http
        .get(Uri.parse(url), headers: {"Access-Control-Allow-Origin": "*"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      _product_pictures =
          data.map<Picture>((json) => Picture.fromJson(json)).toList();
      notifyListeners();
    }
  }

  // Fetch top 3 recent product images
  fetchRecentProductImages(List<String?> pIdL) async {
    _recent_products_pictures = {};
    for (int i = 0; i < pIdL.length; i++) {
      final url = 'http://${dotenv.env['URL']}/apis/v1/image/?product_id=' +
          pIdL[i].toString();
      final response = await http
          .get(Uri.parse(url), headers: {"Access-Control-Allow-Origin": "*"});
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        List<Picture> l =
            data.map<Picture>((json) => Picture.fromJson(json)).toList();
        _recent_products_pictures[pIdL[i]] = l[0];
      }
    }
    notifyListeners();
  }

  // Fetch images based on the category
  fetchCategoryImages() async {
    final url = 'http://${dotenv.env['URL']}/apis/v1/image/?category_id=' +
        c_id.toString();
    final response = await http
        .get(Uri.parse(url), headers: {"Access-Control-Allow-Origin": "*"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<Picture> l =
          data.map<Picture>((json) => Picture.fromJson(json)).toList();
      for (var element in l) {
        {
          _map_of_pictures[element.product_id] = [];
        }
      }
      for (var element in l) {
        {
          (_map_of_pictures[element.product_id])!.add(element);
        }
      }
      notifyListeners();
    }
  }

  // Fetch all the images and store corresponding to product id
  fetchAllImages() async {
    final url = 'http://${dotenv.env['URL']}/apis/v1/image/';
    final response = await http
        .get(Uri.parse(url), headers: {"Access-Control-Allow-Origin": "*"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<Picture> l =
          data.map<Picture>((json) => Picture.fromJson(json)).toList();
      for (var element in l) {
        {
          _map_of_pictures[element.product_id] = [];
        }
      }
      for (var element in l) {
        {
          (_map_of_pictures[element.product_id])!.add(element);
        }
      }
      notifyListeners();
    }
  }

  // Fetch all the images and store according to image id
  fetchTasks() async {
    final url = 'http://${dotenv.env['URL']}/apis/v1/image/?format=json';
    final response = await http
        .get(Uri.parse(url), headers: {"Access-Control-Allow-Origin": "*"});
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<Picture> l =
          data.map<Picture>((json) => Picture.fromJson(json)).toList();
      _pictures = {for (var e in l) e.id: e};
      notifyListeners();
    }
  }
}
