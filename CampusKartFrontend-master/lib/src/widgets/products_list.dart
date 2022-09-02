// Display all the product tiles
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olx_iit_ropar/apis/category_api.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:provider/provider.dart';
import '../../utils/functions.dart';
import 'emptyList.dart';
import "product_container.dart";

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    final productsP = Provider.of<ProductsProvider>(context);
    final categoriesP = Provider.of<CategoryProvider>(context);
    final pictureP = Provider.of<PictureProvider>(context);

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await productsP.fetchCategoryProducts();
          await pictureP.fetchCategoryImages();
        },
        child: productsP.products.entries.isEmpty
            ? EmptyList()
            : ListView(
                padding: const EdgeInsets.all(8.0),
                children: productsP.products.entries.map((entry) {
                  return ProductContainer(entry.value,
                      (categoriesP.categories)[entry.value.category_id]!.name);
                }).toList(),
              ),
      ),
    );
  }
}
