// The screen which holds the BuyProduct widget
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/widgets/app_bar.dart';
import 'package:olx_iit_ropar/src/widgets/bottomappbar.dart';
import 'package:olx_iit_ropar/src/widgets/buy_product.dart';
import 'package:olx_iit_ropar/src/widgets/search_bar.dart';

class BuyProductScreen extends StatefulWidget {
  const BuyProductScreen({Key? key}) : super(key: key);
  @override
  State<BuyProductScreen> createState() => _BuyProductScreenState();
}

class _BuyProductScreenState extends State<BuyProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const <Widget>[
          TitleBar(),
          BuyProduct(),
        ],
      ),
    );
  }
}
