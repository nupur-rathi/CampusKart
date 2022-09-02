import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:olx_iit_ropar/models/image.dart';
import 'package:olx_iit_ropar/models/product.dart';
import 'package:olx_iit_ropar/utils/functions.dart';
import '../models/product.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductsProvider with ChangeNotifier {
  Map<dynamic, Product> _products = {};

  Map<dynamic, Product> get products {
    return {..._products};
  }

  Map<dynamic, Product> _store_products = {};

  Map<dynamic, Product> get storeProducts {
    return {..._store_products};
  }

  Map<dynamic, List<dynamic>> _store_p_images = {};

  Map<dynamic, List<dynamic>> get storePImages {
    return {..._store_p_images};
  }

  Map<dynamic, Product> _recent_products = {};

  Map<dynamic, Product> get recentProducts {
    return {..._recent_products};
  }

  Map<dynamic, Product> _searched_products = {};

  Map<dynamic, Product> get searched_products {
    return {..._searched_products};
  }

  Product? _product;

  Product? get product {
    return _product;
  }

  String p_id = "";
  String curr_url = 'http://${dotenv.env['URL']}/apis/v1/product/';

  void updatePID(input) {
    p_id = input;
    notifyListeners();
  }

  int c_id = 0;

  void updateCID(input) {
    c_id = input;
    notifyListeners();
  }

  // add product api
  Future<String?> addProduct(Product Product) async {
    final response = await http.post(
        Uri.parse('http://${dotenv.env['URL']}/apis/v1/product/'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(Product));
    if (response.statusCode == 201) {
      Product.id = json.decode(response.body)['id'];
      Product.title = json.decode(response.body)['title'];
      Product.category_id = json.decode(response.body)['category_id'];
      Product.description = json.decode(response.body)['description'];
      Product.price = json.decode(response.body)['price'];
      Product.username = json.decode(response.body)['username'];
      Product.time_uploaded = json.decode(response.body)['time_uploaded'];
      Product.selling_reason = json.decode(response.body)['selling_reason'];
      Product.negotiation_status =
          json.decode(response.body)['negotiation_status'];
      Product.time_used = json.decode(response.body)['time_used'];
      Product.brand = json.decode(response.body)['brand'];
      _products[Product.id] = Product;
      notifyListeners();
      var post_data = {
        'title': Product.title,
        'description': Product.description
      };
      final notify_response = await http.post(
          Uri.parse('http://${dotenv.env['URL']}/apis/v1/notification/'),
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode(post_data));
      return Product.id;
    }
    return null;
  }

  // Fetch product api
  fetchProduct() async {
    var url = Uri.parse(
        'http://${dotenv.env['URL']}/apis/v1/product/?product_id=' +
            p_id.toString());
    // get response from URL
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      // Create the map of product with key as product id
      List<Product> l =
          await data.map<Product>((json) => Product.fromJson(json)).toList();
      _product = l[0];
      notifyListeners();
    }
  }

  Future<Product?> fetchProductById(id) async {
    var url = Uri.parse(
        'http://${dotenv.env['URL']}/apis/v1/product/?product_id=' +
            id.toString());
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<Product> l =
          data.map<Product>((json) => Product.fromJson(json)).toList();
      return l[0];
    }
    return null;
  }

  fetchRecentProducts() async {
    var url = Uri.parse('http://${dotenv.env['URL']}/apis/v1/recentProduct/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<Product> l =
          data.map<Product>((json) => Product.fromJson(json)).toList();
      _recent_products = {for (var e in l) e.id: e};
      notifyListeners();
    }
  }

  // fetch your uploaded products
  fetchStoreProducts(u_id) async {
    var temp =
        'http://${dotenv.env['URL']}/apis/v1/product/?user=' + u_id.toString();
    var url = Uri.parse(temp);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<Product> l =
          data.map<Product>((json) => Product.fromJson(json)).toList();
      _store_products = {for (var e in l) e.id: e};
      for (var e in l) {
        _store_p_images[e.id] = await fetchSingleProductImage(e.id);
      }
      notifyListeners();
    }
  }

  // delete a product from database
  deleteProduct(p_id) async {
    final response = await http.delete(
      Uri.parse('http://${dotenv.env['URL']}/apis/v1/product/' +
          p_id.toString() +
          "/"),
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 204) {
      _store_products.remove(p_id);
      _store_p_images.remove(p_id);
      notifyListeners();
    } else {
      throw Exception('Item Not Deleted!');
    }
  }

// fetch products from database
  Future<void> fetchProductsFromDatabase(Uri url) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<Product> l =
          data.map<Product>((json) => Product.fromJson(json)).toList();
      _products = {for (var e in l) e.id: e};
      notifyListeners();
    }
  }

  // fetch products list by category id
  fetchCategoryProducts() async {
    var temp = 'http://${dotenv.env['URL']}/apis/v1/product/?category_id=' +
        c_id.toString();
    var url = Uri.parse(temp);
    curr_url = temp;
    await fetchProductsFromDatabase(url);
  }

  // fetch sorted products list
  fetchSortProducts(String stype) async {
    var temp = curr_url;
    if (curr_url.contains("sort"))
      temp = curr_url.replaceAll(RegExp(r'sort=[a-zA-Z0-9]+'), 'sort=' + stype);
    else
      temp = curr_url + '&sort=' + stype;
    var url = Uri.parse(temp);
    curr_url = temp;
    await fetchProductsFromDatabase(url);
  }

// fetch filtered products list
  fetchFilterProducts(int value, bool isCheckedY, bool isCheckedN) async {
    var temp = curr_url;
    if (curr_url.contains("filter"))
      temp = curr_url.replaceAll(
          RegExp(r'filter=[0-9]+'), 'filter=' + value.toString());
    else
      temp = curr_url + '&filter=' + value.toString();
    if (isCheckedY == isCheckedN) {
      if (temp.contains("neg_status"))
        temp =
            temp.replaceAll(RegExp(r'neg_status=[a-zA-Z]+'), 'neg_status=All');
      else
        temp = temp;
    } else {
      var status = "";
      if (isCheckedY == true)
        status = "True";
      else
        status = "False";
      if (temp.contains("neg_status"))
        temp = temp.replaceAll(
            RegExp(r'neg_status=[a-zA-Z]+'), 'neg_status=' + status);
      else
        temp = temp + '&neg_status=' + status;
    }
    var url = Uri.parse(temp);
    curr_url = temp;
    await fetchProductsFromDatabase(url);
  }

// search products by term passed as argument
  fetchSearchProducts(term) async {
    var temp = 'http://${dotenv.env['URL']}/apis/v1/product/?search=' + term;
    var url = Uri.parse(temp);
    curr_url = temp;
    await fetchProductsFromDatabase(url);
  }

// fetch products by owner username passed as argument
  fetchOwnerProducts(term) async {
    var temp = 'http://${dotenv.env['URL']}/apis/v1/product/?owner=' + term;
    var url = Uri.parse(temp);
    curr_url = temp;
    await fetchProductsFromDatabase(url);
  }

  fetchTasks() async {
    var temp = 'http://${dotenv.env['URL']}/apis/v1/product/';
    var url = Uri.parse(temp);
    curr_url = temp;
    await fetchProductsFromDatabase(url);
  }

  updateProduct(Product product) async {
    final response = await http.put(
        Uri.parse('http://${dotenv.env['URL']}/apis/v1/product/${product.id}/'),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(product));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var p_id = data["id"];
      return p_id;
    }
  }
}
