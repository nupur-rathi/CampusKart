// The whole products list body with bottom sheet for filtering and sorting
import 'package:flutter/material.dart';
import "filter_bar.dart";
import 'products_list.dart';

class ProductsBody extends StatefulWidget {
  const ProductsBody({Key? key}) : super(key: key);

  @override
  _ProductsBodyState createState() => _ProductsBodyState();
}

class _ProductsBodyState extends State<ProductsBody> {
  bool _showBottomSheet = false;

  void setShowBS(bool input) {
    setState(() {
      _showBottomSheet = input;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            ProductsList(),
            if (_showBottomSheet == false) FilterBar(),
          ],
        ),
      ),
    );
  }
}
