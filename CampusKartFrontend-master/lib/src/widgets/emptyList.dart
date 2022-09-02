// When no products to show, show this widget
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olx_iit_ropar/apis/category_api.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:provider/provider.dart';
import '../../utils/functions.dart';
import "product_container.dart";

class EmptyList extends StatefulWidget {
  @override
  _EmptyListState createState() => _EmptyListState();
}

class _EmptyListState extends State<EmptyList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "\"No products found\"",
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 100.0,
                  child: Image.asset("lib/assets/random/emoji.png"),
                ),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
