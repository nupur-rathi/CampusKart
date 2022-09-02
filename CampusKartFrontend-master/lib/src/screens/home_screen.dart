// This is the home page for the app
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:olx_iit_ropar/src/widgets/app_bar.dart';
import 'package:olx_iit_ropar/src/widgets/search_bar.dart';
import 'package:olx_iit_ropar/src/widgets/bottomappbar.dart';
import 'package:olx_iit_ropar/src/widgets/home_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:olx_iit_ropar/models/user.dart' as AddUser;
import 'package:olx_iit_ropar/models/image.dart';
import 'package:olx_iit_ropar/apis/user_api.dart';
import 'package:provider/provider.dart';

late User loggedinUser;
late Future<AddUser.User> current_user;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    current_user = function();
  }

  // funtion to get the current user
  Future<AddUser.User> function() async {
    try {
      final User? user = await _auth.currentUser;
      if (user != null && (user.emailVerified)) {
        loggedinUser = user;
        Map<dynamic, AddUser.User> userMap =
            await Provider.of<UserProvider>(context, listen: false)
                .fetchTasks();
        String email = loggedinUser.email as String;
        String usernameVar = email.substring(0, email.length - 13);
        return userMap[usernameVar]!;
      }
    } catch (e) {
      print(e);
      throw ("Error at the current User function");
    }
    throw ("Error at the current User function");
  }

  @override
  Widget build(BuildContext context) {
    // if back button is pressed on the home screen, then we exit the app
    return WillPopScope(
      onWillPop: () async {
        exit(0);
        return false;
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            TitleBar(),
            SearchBar(),
            HomeBody(),
          ],
        ),
        bottomNavigationBar: const BottomBar(),
      ),
    );
  }
}
