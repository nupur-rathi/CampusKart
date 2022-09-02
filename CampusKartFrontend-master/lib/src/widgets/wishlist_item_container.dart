// A simple card for one wishlist item
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../../apis/image_api.dart';
import '../../apis/liked_product_api.dart';
import '../../apis/product_api.dart';

class WishlistItemContainer extends StatefulWidget {
  final String key_id;
  final String? id;
  final String title;
  final int price;
  final String imageURL;
  const WishlistItemContainer(
      this.key_id, this.id, this.title, this.price, this.imageURL);

  @override
  _WishlistItemContainerState createState() => _WishlistItemContainerState();
}

class _WishlistItemContainerState extends State<WishlistItemContainer> {
  Widget _buildProductImage() {
    return Container(
      width: MediaQuery.of(context).size.width / 2.3,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        image: DecorationImage(
          image: NetworkImage(widget.imageURL),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    final likedP = Provider.of<LikedProductsProvider>(context);

    return Container(
      padding: const EdgeInsets.all(0.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      height: 30.0,
      alignment: Alignment.centerRight,
      child: IconButton(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(0.0),
        iconSize: 20.0,
        icon: const Icon(
          Icons.clear_rounded,
        ),
        onPressed: () {
          likedP.deleteLikedProduct(widget.key_id);
        },
      ),
    );
  }

  Widget _buildProductTitle() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10.0),
      child: RichText(
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
            style: const TextStyle(fontSize: 16.0, color: Color(0xFF616161)),
            text: widget.title),
        maxLines: 3,
      ),
    );
  }

  Widget _buildProductPrice() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        "₹ " + widget.price.toString(),
        style: const TextStyle(
          fontSize: 18.0,
          color: Color(0xFFC62828),
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(
            left: 15.0, right: 15.0, top: 0.0, bottom: 0.0),
        child: Column(
          children: <Widget>[
            _buildDeleteButton(),
            _buildProductTitle(),
            _buildProductPrice(),
            // _buildBuyButton(),
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
        productP.updatePID(widget.id);
        EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
        );
        await pictureP.fetchProductImages(widget.id);
        await productP.fetchProduct();
        EasyLoading.dismiss();
        Navigator.pushNamed(context, '/buy_product_screen');
      },
      child: Card(
        elevation: 1.5,
        margin: const EdgeInsets.only(bottom: 30.0),
        child: Container(
          height: 200,
          alignment: Alignment.center,
          child: Row(
            children: [
              _buildProductImage(),
              _buildProductDetails(),
            ],
          ),
        ),
      ),
    );
  }
}
