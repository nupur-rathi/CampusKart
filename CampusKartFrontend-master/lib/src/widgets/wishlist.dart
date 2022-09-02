// Containing all the wishlist products and the app bar
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:olx_iit_ropar/models/liked_product.dart';
import 'package:olx_iit_ropar/models/product.dart';
import 'package:olx_iit_ropar/src/widgets/wishlist_item_container.dart';
import 'package:olx_iit_ropar/utils/functions.dart';
import 'package:provider/provider.dart';
import '../../apis/liked_product_api.dart';
import 'products_list.dart';
import 'package:flutter/material.dart';
import "product_container.dart";

class UserWishList {
  late int id;
  late String title;
  late double price;
  late String imageURL;

  UserWishList(this.id, this.title, this.price, this.imageURL);
}

List<UserWishList> user_wishlist = [
  UserWishList(
      1,
      "cycle1 with great gears and seats, black colour, yellow paint, nice cycle, must buy",
      3000.00,
      "https://images.unsplash.com/photo-1485965120184-e220f721d03e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"),
  UserWishList(
      2,
      "cycle2 with great gears and seats, black colour, yellow paint, nice cycle, must buy",
      2500.00,
      "https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1122&q=80"),
  UserWishList(
      3,
      "cycle1 with great gears and seats, black colour, yellow paint, nice cycle, must buy",
      3000.00,
      "https://images.unsplash.com/photo-1485965120184-e220f721d03e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"),
  UserWishList(
      4,
      "cycle2 with great gears and seats, black colour, yellow paint, nice cycle, must buy",
      2500.00,
      "https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1122&q=80"),
  UserWishList(
      5,
      "cycle1 with great gears and seats, black colour, yellow paint, nice cycle, must buy",
      3000.00,
      "https://images.unsplash.com/photo-1485965120184-e220f721d03e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"),
  UserWishList(
      6,
      "cycle2 with great gears and seats, black colour, yellow paint, nice cycle, must buy",
      2500.00,
      "https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1122&q=80"),
];

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  Widget _buildWishlistContainer() {
    final likedP = Provider.of<LikedProductsProvider>(context);

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: likedP.Wishlist.entries.map((entry) {
          return WishlistItemContainer(
              entry.key,
              entry.value.id,
              entry.value.title,
              entry.value.price,
              likedP.Wishlist_Img[entry.key]!.image);
        }).toList(),
      ),
    );
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
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Your Wishlist",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            _buildWishlistContainer(),
          ],
        ),
      ),
    );
  }
}
