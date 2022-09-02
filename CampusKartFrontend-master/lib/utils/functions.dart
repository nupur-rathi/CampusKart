import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart' as FUser;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:olx_iit_ropar/models/image.dart';
import 'package:olx_iit_ropar/models/product.dart';
import 'package:olx_iit_ropar/models/user.dart';
import '../models/liked_product.dart';

// funtion to fetch recent products and their images from backend and display them
Future<List<Picture>> recentProductsDisplay(
    final productsP, final picturesP) async {
  List<Picture> imageList = [];
  // fetching recent products api
  await productsP.fetchRecentProducts();
  List<String?> p_ids = [];
  for (var k in productsP.recentProducts.keys) {
    p_ids.add(productsP.recentProducts[k]!.id);
  }
  //fetching images of recent products from backend using product id
  await picturesP.fetchRecentProductImages(p_ids);
  for (var v in picturesP.recentProductPictures.values) {
    imageList.add(v);
  }
  return imageList;
}

//api to fetch images of given product id
Future<List> fetchSingleProductImage(p_id) async {
  final url = 'http://${dotenv.env['URL']}/apis/v1/image/?product_id=' +
      p_id.toString();
  final response = await http
      .get(Uri.parse(url), headers: {"Access-Control-Allow-Origin": "*"});
  if (response.statusCode == 200) {
    var data = json.decode(response.body) as List;
    List<Picture> _product_pictures = [];
    _product_pictures =
        data.map<Picture>((json) => Picture.fromJson(json)).toList();
    return _product_pictures;
  }
  return [];
}

// api to get the username information from firebase
getUser() {
  final FUser.FirebaseAuth auth = FUser.FirebaseAuth.instance;
  final FUser.User? user = auth.currentUser;
  print(user!.email);
  var username = user.email!.substring(0, user.email!.length - 13);
  return username;
}

//api to fetch user information like username, phone number, email from backend using username
fetchUser(userID) async {
  var url = Uri.parse(
      'http://${dotenv.env['URL']}/apis/v1/user/?u_id=' + userID.toString());
  final response = await http.get(url);
  if (response.statusCode == 200) {
    var data = json.decode(response.body) as List;
    List<User> l = await data.map<User>((json) => User.fromJson(json)).toList();
    return l[0];
  }
}

// fetch api to fetch product information using product ID
fetchProductInfo(p_id) async {
  var url = Uri.parse(
      'http://${dotenv.env['URL']}/apis/v1/product/?product_id=' +
          p_id.toString());
  final response = await http.get(url);
  if (response.statusCode == 200) {
    var data = json.decode(response.body) as List;
    List<Product> l =
        await data.map<Product>((json) => Product.fromJson(json)).toList();
    return l[0];
  }
}

// fetch api to fetch users wishlisted product from backend
fetchLikedProduct(id) async {
  var url = Uri.parse(
      'http://${dotenv.env['URL']}/apis/v1/likedpro/' + id.toString() + '/');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    var data = json.decode(response.body) as List;
    List<LikedProducts> l = await data
        .map<LikedProducts>((json) => LikedProducts.fromJson(json))
        .toList();
    return l[0];
  } else {
    throw Exception('Item Not found!');
  }
}

// fetch api to fetch users uploaded product from backend
fetchStoreProducts(u_id) async {
  var temp =
      'http://${dotenv.env['URL']}/apis/v1/product/?user=' + u_id.toString();
  var url = Uri.parse(temp);
  final response = await http.get(url);
  if (response.statusCode == 200) {
    var data = json.decode(response.body) as List;
    List<Product> l =
        data.map<Product>((json) => Product.fromJson(json)).toList();
    var _store_products = {for (var e in l) e.id: e};
    return _store_products;
  }
}

//navigation function to navigate to a page
void navigation(BuildContext context, routeName) {
  final newRouteName = routeName;
  bool isNewRouteSameAsCurrent = false;

  // pop from naviagtor stack while the same page is present
  Navigator.popUntil(context, (route) {
    if (route.settings.name == newRouteName) {
      isNewRouteSameAsCurrent = true;
    }
    return true;
  });

  // push the page to navigator stack
  if (!isNewRouteSameAsCurrent) {
    Navigator.pushNamed(context, newRouteName);
  }
}