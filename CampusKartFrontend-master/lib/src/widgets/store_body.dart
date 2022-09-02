// To show the list of products uploaded by the user
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:olx_iit_ropar/src/widgets/store_cards.dart';
import 'package:olx_iit_ropar/utils/constants.dart';
import 'package:olx_iit_ropar/utils/functions.dart';
import 'package:provider/provider.dart';

class StoreBody extends StatefulWidget {
  const StoreBody();

  @override
  _StoreBodyState createState() => _StoreBodyState();
}

class _StoreBodyState extends State<StoreBody> {
  Widget _buildHeader() {
    return Container(
      alignment: Alignment.centerLeft,
      padding:
          EdgeInsets.only(left: 15.0, top: 20.0, bottom: 10.0, right: 10.0),
      child: Text('Your Uploaded Products',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Color(primary_color))),
    );
  }

  Widget _buildSizedBox(input) {
    return SizedBox(
      height: input,
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsP = Provider.of<ProductsProvider>(context);

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: productsP.storeProducts.entries.map((entry) {
          return StoreCards(entry.value);
        }).toList(),
      ),
    );
  }
}
