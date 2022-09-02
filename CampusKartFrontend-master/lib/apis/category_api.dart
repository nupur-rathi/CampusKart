import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import '../models/category.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

//category provider to provide a single state management unit for categories on frontend side with various apis to connect with backend
class CategoryProvider with ChangeNotifier {
  CategoryProvider() {
    fetchTasks();
  }

  Map<dynamic, Category> _categories = {};

  Map<dynamic, Category> get categories {
    return {..._categories};
  }

  Future<String?> fetchCategoryById(category_id) async {
    var url = Uri.parse(
        'http://${dotenv.env['URL']}/apis/v1/category/${category_id}/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data["name"];
    }
    return null;
  }

  // Fetch all the categories
  fetchTasks() async {
    var url = Uri.parse('http://${dotenv.env['URL']}/apis/v1/category/');
    // Get response from URL
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      List<Category> l =
          data.map<Category>((json) => Category.fromJson(json)).toList();
      // Create the map of categories with key as category id
      _categories = {for (var e in l) e.id: e};
      notifyListeners();
    }
  }
}
