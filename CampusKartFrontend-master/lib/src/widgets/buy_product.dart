// This page will show a particular product
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:olx_iit_ropar/models/liked_product.dart';
import 'package:olx_iit_ropar/src/widgets/Carousel.dart';
import 'package:olx_iit_ropar/utils/constants.dart';
import 'package:olx_iit_ropar/apis/liked_product_api.dart';
import 'package:provider/provider.dart';
import 'contact_seller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BuyProduct extends StatefulWidget {
  const BuyProduct();

  @override
  _BuyProductState createState() => _BuyProductState();
}

class _BuyProductState extends State<BuyProduct> {
  bool ifLiked = false;

  var pictureP;
  var productP;
  var pro_id;
  var username;
  void func(pro_id, username) async {
    var temp = await Provider.of<LikedProductsProvider>(context, listen: false)
        .ifExists(pro_id, username);
    setState(() {
      ifLiked = temp;
    });
  }

  void initState() {
    setState(() {
      pictureP = Provider.of<PictureProvider>(context, listen: false);
      productP = Provider.of<ProductsProvider>(context, listen: false);
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    print(user!.email);
    setState(() {
      username = user.email!.substring(0, user.email!.length - 13);
      pro_id = productP.product!.id;
    });
    func(pro_id, username);
  }

  Widget _buildContact(productP) {
    return MaterialButton(
      height: 50.0,
      minWidth: MediaQuery.of(context).size.width / 1.1,
      color: Color(primary_color),
      splashColor: const Color(0xff2CA4FF),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ContactSeller(productP.product!.id);
          },
        );
      },
      child: const Text(
        'Contact',
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String t_u = productP.product.time_used.toString();
    int pos1 = t_u.indexOf('-');
    String years = t_u.substring(0, pos1);
    int pos2 = t_u.indexOf('-', pos1 + 1);
    String months = t_u.substring(pos1 + 1, pos2);
    String days = t_u.substring(pos2 + 1);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: Carousel(260.0, pictureP.productPictures, false),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      productP.product!.title,
                      softWrap: true,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          ifLiked = !ifLiked;
                          if (ifLiked) {
                            if (pro_id != null) {
                              final LikedProducts likedProduct = LikedProducts(
                                  username: username, product_id: pro_id);
                              var ans = Provider.of<LikedProductsProvider>(
                                      context,
                                      listen: false)
                                  .addLikedProduct(likedProduct);
                            }
                          } else {
                            if (pro_id != null) {
                              Provider.of<LikedProductsProvider>(context,
                                      listen: false)
                                  .fetchDeleteLikedProduct(pro_id, username);
                            }
                          }
                        });
                      },
                      icon: const Icon(Icons.favorite, size: 20.0),
                      color: ifLiked
                          ? const Color.fromARGB(255, 173, 0, 0)
                          : const Color(0xFF616161),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                    r"Uploaded on: " +
                        productP.product.time_uploaded
                            .toString()
                            .substring(0, 10),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    )),
                const SizedBox(height: 5),
                Text(r"User: " + productP.product.username.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    )),
                const SizedBox(height: 22),
                Text(r"Price: ₹" + productP.product!.price.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Colors.green,
                    )),
                const SizedBox(height: 40),
                Text(
                    r"Brand: " +
                        (productP.product.brand == ""
                            ? "Not available"
                            : productP.product!.brand.toString()),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.grey[900],
                    )),
                const SizedBox(height: 15),
                Text(
                    r"Reason for selling: " +
                        (productP.product.selling_reason == ""
                            ? "Not available"
                            : productP.product!.selling_reason.toString()),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.grey[900],
                    )),
                const SizedBox(height: 15),
                Text(
                    r"Time used: " +
                        (productP.product.time_used == ""
                            ? "Not available"
                            : years +
                                " years " +
                                months +
                                " months " +
                                days +
                                " days"),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.grey[900],
                    )),
                const SizedBox(height: 30),
                const Text(r"Description: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    )),
                Html(
                  data: productP.product!.description,
                  //Optional parameters:
                  onLinkTap: (url) {
                    // open url in a webview
                  },
                  onImageTap: (src) {
                    // Display the image in large form.
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(r"Open to negotiation: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                    Text((productP.product.negotiation_status ? "Yes" : "No"),
                        style: TextStyle(
                          fontSize: 15,
                          color: productP.product.negotiation_status
                              ? Colors.green
                              : Colors.red,
                        )),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: const EdgeInsets.all(10.0),
                width: double.infinity,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [_buildContact(productP)])),
          ),
        ],
      ),
    );
  }
}
