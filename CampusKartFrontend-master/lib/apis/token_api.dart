import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/token.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:olx_iit_ropar/models/token.dart';

class TokenProvider with ChangeNotifier {
  TokenProvider() {
  }

  // api to add token (generated on app login) to database
  Future<Token?> addToken(Token token) async {
    final response =
        await http.post(Uri.parse('http://${dotenv.env['URL']}/apis/v1/token/'),
            headers: {
              "Content-Type": "application/json",
            },
            body: json.encode(token));
    if (response.statusCode == 201) {
      token.id = json.decode(response.body)['id'];
      token.username = json.decode(response.body)['username'];
      token.token = json.decode(response.body)['token'];
      notifyListeners();
      return token;
    }
    return null;
  }

// api to delete token from database(on sign out)
  void deleteToken(String id) async {
    final response = await http
        .delete(Uri.parse('http://${dotenv.env['URL']}/apis/v1/token/${id}/'));
    if (response.statusCode == 204) {
      notifyListeners();
    }
  }
}
