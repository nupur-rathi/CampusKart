// A single card for showing the uploaded products by the user
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:olx_iit_ropar/models/category.dart';
import 'package:olx_iit_ropar/models/product.dart';
import 'package:olx_iit_ropar/src/screens/upload_product_screen.dart';
import 'package:olx_iit_ropar/utils/functions.dart';
import 'package:provider/provider.dart';

import '../../apis/category_api.dart';

class StoreCards extends StatefulWidget {
  final Product product;
  const StoreCards(this.product);

  @override
  _StoreCardsState createState() => _StoreCardsState();
}

class _StoreCardsState extends State<StoreCards> {
  Future<void> _showDeleteDialog() async {
    final productsP = Provider.of<ProductsProvider>(context, listen: false);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await productsP.deleteProduct(widget.product.id);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDeleteButton() {
    return Container(
      padding: const EdgeInsets.all(0.0),
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: 35.0,
        width: 35.0,
        child: IconButton(
          iconSize: 35.0,
          padding: const EdgeInsets.all(0.0),
          onPressed: () {
            _showDeleteDialog();
          },
          icon: const Icon(
            Icons.delete_forever_rounded,
          ),
        ),
      ),
    );
  }

  Product? p;
  var category_name;

  getProductDetails() async {
    p = await Provider.of<ProductsProvider>(context, listen: false)
        .fetchProductById(widget.product.id);

    category_name = await Provider.of<CategoryProvider>(context, listen: false)
        .fetchCategoryById(p!.category_id);
  }

  Widget _buildEditButton() {
    return Container(
      padding: const EdgeInsets.all(0.0),
      alignment: Alignment.centerRight,
      child: SizedBox(
        height: 35.0,
        width: 35.0,
        child: IconButton(
          iconSize: 35.0,
          padding: const EdgeInsets.all(0.0),
          onPressed: () async {
            await getProductDetails();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    UploadProductScreen(product: p, category: category_name),
              ),
            );
            // _showDeleteDialog();
          },
          icon: const Icon(
            Icons.edit_outlined,
          ),
        ),
      ),
    );
  }

  ImageProvider<Object> _buildImage(productP) {
    if (productP.storePImages[widget.product.id].length > 0) {
      return NetworkImage(productP.storePImages[widget.product.id][0].image);
    } else {
      return const AssetImage('assets/logos/shopping-cart.png');
    }
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
      child: SizedBox(
        height: MediaQuery.of(context).size.width / 2.0,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2.0,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  image: DecorationImage(
                    image: _buildImage(productP),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.title,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 17.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildEditButton(),
                            SizedBox(width: 10.0),
                            _buildDeleteButton(),
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 2,
          margin:
              const EdgeInsets.only(top: 10, right: 10, bottom: 0, left: 10),
        ),
      ),
    );
  }
}
