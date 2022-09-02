// Widget for home page showing recent products and categories
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:olx_iit_ropar/models/image.dart';
import 'package:olx_iit_ropar/src/widgets/Carousel.dart';
import 'package:olx_iit_ropar/src/widgets/gridlist.dart';
import 'package:olx_iit_ropar/utils/functions.dart';
import 'package:provider/provider.dart';

class HomeBody extends StatefulWidget {
  List<Picture> imageList = [];
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  var once = true;

  Widget _buildSizedBox(double size) {
    return SizedBox(
      height: size,
    );
  }

  // Widget to show the recent products
  Widget _buildRecentProducts() {
    if (widget.imageList.isEmpty) {
      return Container(
        width: double.infinity,
        child: Column(
          children: [
            _buildSizedBox(20.0),
            Container(
              child: const Text(
                "Recent Products",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            _buildSizedBox(15.0),
            Container(
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Be the first one to upload :)",
                    style: const TextStyle(fontSize: 18),
                  ),
                  _buildSizedBox(10.0),
                  Container(
                    height: 110.0,
                    child: GestureDetector(
                        onTap: () {
                          navigation(context, '/upload_product_screen');
                        },
                        child: Image.asset("lib/assets/random/upload.png")),
                  ),
                  _buildSizedBox(15.0),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          _buildSizedBox(20.0),
          Container(
            child: const Text(
              "Recent Products",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          _buildSizedBox(10.0),
          Carousel(250.0, widget.imageList, true),
          _buildSizedBox(15.0),
        ],
      ),
    );
  }

  // For showing the categories
  Widget _buildCategories() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          _buildSizedBox(20.0),
          Container(
            child: const Text(
              "Browse Categories",
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          _buildSizedBox(20.0),
          CategoriesList(),
          _buildSizedBox(15.0),
        ],
      ),
    );
  }

  // To fetch the recent products data
  Future getData(productsP, picturesP) async {
    var x = await recentProductsDisplay(productsP, picturesP);
    setState(() {
      widget.imageList = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsP = Provider.of<ProductsProvider>(context, listen: false);
    final picturesP = Provider.of<PictureProvider>(context, listen: false);
    if (once) {
      getData(productsP, picturesP);
    }

    once = false;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          getData(productsP, picturesP);
        },
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                _buildRecentProducts(),
                _buildSizedBox(12.0),
                _buildCategories(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
