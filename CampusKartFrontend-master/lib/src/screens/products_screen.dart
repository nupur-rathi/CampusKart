// Container screen for products_body to display product list
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/widgets/Carousel.dart';
import 'package:olx_iit_ropar/src/widgets/app_bar.dart';
import 'package:olx_iit_ropar/src/widgets/products_body.dart';
import 'package:olx_iit_ropar/src/widgets/search_bar.dart';
import 'package:olx_iit_ropar/src/widgets/upload_product.dart';
import 'package:olx_iit_ropar/src/widgets/bottomappbar.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const <Widget>[
          TitleBar(),
          SearchBar(),
          ProductsBody(),
        ],
      ),
    );
  }
}
