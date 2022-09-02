// Common bottom bar for all the pages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:olx_iit_ropar/models/image.dart';
import 'package:olx_iit_ropar/utils/constants.dart';
import 'package:olx_iit_ropar/utils/functions.dart';
import 'package:provider/provider.dart';
import '../../apis/user_api.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    List<Picture> imageList = [];
    final productsP = Provider.of<ProductsProvider>(context);
    final picturesP = Provider.of<PictureProvider>(context);

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Color(primary_color),
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Wrap(
          alignment: WrapAlignment.spaceAround,
          children: <Widget>[
            // Show the options for home, upload and profile on bottom bar
            IconButton(
              tooltip: 'Home',
              icon: const Icon(Icons.home_outlined, size: 22),
              onPressed: () async {
                navigation(context, "/home_page");
              },
            ),
            IconButton(
              tooltip: 'Upload',
              icon: const Icon(Icons.add_circle_rounded, size: 30),
              onPressed: () {
                navigation(context, '/upload_product_screen');
              },
            ),
            IconButton(
              tooltip: 'Profile',
              icon: const Icon(Icons.person_outline_rounded, size: 22),
              onPressed: () {
                navigation(context, '/profile_screen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
