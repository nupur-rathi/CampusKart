import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/models/image.dart';
import 'package:olx_iit_ropar/models/product.dart';
import 'package:olx_iit_ropar/utils/functions.dart';
import '../models/liked_product.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LikedProductsProvider with ChangeNotifier {
  Map<dynamic, LikedProducts> _likedProducts = {};

  Map<dynamic, LikedProducts> get likedProducts {
    return {..._likedProducts};
  }

  Map<dynamic, Picture> _wishlist_img = {};

  Map<dynamic, Picture> get Wishlist_Img {
    return {..._wishlist_img};
  }

  Map<dynamic, Product> _wishlist = {};

  Map<dynamic, Product> get Wishlist {
    return {..._wishlist};
  }

  // Add liked product to the database
  void addLikedProduct(LikedProducts LikedProducts) async {
    final response = await http.post(
        Uri.parse('http://${dotenv.env['URL']}/apis/v1/likedpro/'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(LikedProducts));
    if (response.statusCode == 201) {
      LikedProducts.id = json.decode(response.body)['id'];
      LikedProducts.username = json.decode(response.body)['username'];
      LikedProducts.product_id = json.decode(response.body)['product_id'];
      _likedProducts[LikedProducts.id] = LikedProducts;
      notifyListeners();
    }
  }

  // Delete the liked product from the database
  fetchDeleteLikedProduct(p_id, u_id) async {
    var url = Uri.parse('http://${dotenv.env['URL']}/apis/v1/likedpro/?p_id=' +
        p_id.toString() +
        '&u_id=' +
        u_id.toString());
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<LikedProducts> l = data
          .map<LikedProducts>((json) => LikedProducts.fromJson(json))
          .toList();
      await deleteLikedProduct(l[0].id.toString());
    } else {
      throw Exception('Item Not found!');
    }
  }

  Future<bool> ifExists(p_id, u_id) async {
    var url = Uri.parse('http://${dotenv.env['URL']}/apis/v1/likedpro/?p_id=' +
        p_id.toString() +
        '&u_id=' +
        u_id.toString());
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<LikedProducts> l = data
          .map<LikedProducts>((json) => LikedProducts.fromJson(json))
          .toList();
      return l.isNotEmpty;
    } else {
      return false;
    }
  }

  Future<void> deleteLikedProduct(id) async {
    final response2 = await http.delete(
      Uri.parse('http://${dotenv.env['URL']}/apis/v1/likedpro/' +
          id.toString() +
          "/"),
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response2.statusCode == 204) {
      _likedProducts.remove(id);
      _wishlist.remove(id);
      _wishlist_img.remove(id);
      notifyListeners();
    } else {
      throw Exception('Item Not Deleted!');
    }
  }

  fetchLikedProducts(u_id) async {
    var url = Uri.parse(
        'http://${dotenv.env['URL']}/apis/v1/likedpro/?username=' +
            u_id.toString());
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<LikedProducts> l = data
          .map<LikedProducts>((json) => LikedProducts.fromJson(json))
          .toList();
      _likedProducts = Map.fromIterable(l, key: (e) => e.id, value: (e) => e);
      _wishlist = {};
      _wishlist_img = {};
      for (var v in l) {
        Product p = await fetchProductInfo(v.product_id);
        List lp = await fetchSingleProductImage(v.product_id);
        _wishlist[v.id] = p;
        _wishlist_img[v.id] = lp[0];
      }
      notifyListeners();
    }
  }

  fetchTasks() async {
    var url = Uri.parse('http://${dotenv.env['URL']}/apis/v1/likedpro/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<LikedProducts> l = data
          .map<LikedProducts>((json) => LikedProducts.fromJson(json))
          .toList();
      _likedProducts = Map.fromIterable(l, key: (e) => e.id, value: (e) => e);
      notifyListeners();
    }
  }
}
