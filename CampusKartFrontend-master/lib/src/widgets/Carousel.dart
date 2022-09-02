// To show the images in a carousel
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:olx_iit_ropar/utils/constants.dart';
import 'package:provider/provider.dart';
import '../../models/image.dart';

class Carousel extends StatefulWidget {
  final double height;
  late List<Picture> imageList = [];
  final bool isGesture;
  Carousel(this.height, this.imageList, this.isGesture, {Key? key})
      : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  @override
  Widget build(BuildContext context) {
    final pictureP = Provider.of<PictureProvider>(context);
    final productP = Provider.of<ProductsProvider>(context);

    final width = MediaQuery.of(context).size.width;
    return CarouselSlider(
      options: CarouselOptions(
        height: widget.height,
        autoPlay: true,
      ),
      items: widget.imageList
          .map(
            (item) => GestureDetector(
              onTap: () async {
                if (widget.isGesture) {
                  productP.updatePID(item.product_id);
                  EasyLoading.show(
                    status: 'loading...',
                    maskType: EasyLoadingMaskType.black,
                  );
                  await pictureP.fetchProductImages(item.product_id);
                  await productP.fetchProduct();
                  EasyLoading.dismiss();
                  Navigator.pushNamed(context, '/buy_product_screen');
                }
              },
              child: Container(
                child: Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(2.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(
                          item.image,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
