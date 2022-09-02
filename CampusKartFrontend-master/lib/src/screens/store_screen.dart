// Shows all the uploaded products by a user
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/widgets/bottomappbar.dart';
import 'package:olx_iit_ropar/src/widgets/store_body.dart';
import 'package:olx_iit_ropar/utils/constants.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);
  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Your Uploaded Products",
          style: TextStyle(color: Color(primary_color)),
        ),
        automaticallyImplyLeading: false,
        elevation: 0.1,
      ),
      body: Column(
        children: const <Widget>[
          StoreBody(),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
