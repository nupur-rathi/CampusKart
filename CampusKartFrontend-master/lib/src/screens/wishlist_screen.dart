// Shows the wishlist products
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/widgets/app_bar.dart';
import 'package:olx_iit_ropar/src/widgets/bottomappbar.dart';
import 'package:olx_iit_ropar/src/widgets/wishlist.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);
  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const <Widget>[
          TitleBar(),
          Wishlist(),
        ],
      ),
    );
  }
}
