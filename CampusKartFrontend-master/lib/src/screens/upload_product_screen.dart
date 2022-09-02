// Screen to upload products to the app
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/widgets/app_bar.dart';
import 'package:olx_iit_ropar/src/widgets/upload_product.dart';
import 'package:olx_iit_ropar/src/widgets/bottomappbar.dart';

class UploadProductScreen extends StatefulWidget {
  var product, category;
  UploadProductScreen({this.product, this.category});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 40),
          UploadProductForm(product: widget.product, category: widget.category),
        ],
      ),
    );
  }
}
