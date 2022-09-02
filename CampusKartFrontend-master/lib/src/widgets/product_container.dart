// Tile of a product to display in the list
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:olx_iit_ropar/models/category.dart';
import 'package:olx_iit_ropar/models/product.dart';
import 'package:provider/provider.dart';

class ProductContainer extends StatefulWidget {
  final Product product;
  final String c_name;
  const ProductContainer(this.product, this.c_name);

  @override
  _ProductContainerState createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  ImageProvider<Object> _buildImage() {
    final pictureP = Provider.of<PictureProvider>(context);
    if (pictureP.mapPictures.containsKey(widget.product.id)) {
      return NetworkImage(pictureP.mapPictures[widget.product.id]![0].image);
    } else {
      return const AssetImage('assets/random/shopping-cart.png');
    }
  }

  Widget _buildProductImage() {
    final pictureP = Provider.of<PictureProvider>(context);

    return Container(
      width: MediaQuery.of(context).size.width / 2.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: _buildImage(),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildProductTitle() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15.0),
      child: RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
            style: const TextStyle(fontSize: 16.0, color: Color(0xFF616161)),
            text: widget.product.title),
        maxLines: 3,
      ),
    );
  }

  Widget _buildProductPrice() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        "₹ " + widget.product.price.toString(),
        style: const TextStyle(
          fontSize: 20.0,
          color: Color(0xFFC62828),
        ),
      ),
    );
  }

  Widget _buildBuyButton() {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.yellow,
        minimumSize: const Size.fromHeight(10.0), // NEW
      ),
      child: const Text('Buy',
          style: TextStyle(fontSize: 15.0, color: Colors.black)),
      onPressed: () {},
    );
  }

  Widget _buildAddToWishlist() {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      height: 20,
      child: IconButton(
        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.centerLeft,
        color: const Color(0xFF616161),
        onPressed: () {},
        icon: const Icon(Icons.favorite_border_outlined, size: 20.0),
      ),
    );
  }

  Widget _buildProductType() {
    return Container(
      color: Colors.green[200],
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Text(widget.c_name, style: const TextStyle(fontSize: 12.5)),
    );
  }

  Widget _buildProductDetails() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildProductType(),
            _buildProductTitle(),
            _buildProductPrice(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pictureP = Provider.of<PictureProvider>(context);
    final productP = Provider.of<ProductsProvider>(context);

    return GestureDetector(
      onTap: () async {
        productP.updatePID(widget.product.id);
        EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        );
        await pictureP.fetchProductImages(widget.product.id);
        await productP.fetchProduct();
        EasyLoading.dismiss();
        Navigator.pushNamed(context, '/buy_product_screen');
      },
      child: Container(
        height: 200,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.2, color: Color(0xFF616161)),
          ),
        ),
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 15.0),
        child: Row(
          children: [
            _buildProductImage(),
            _buildProductDetails(),
          ],
        ),
      ),
    );
  }
}
