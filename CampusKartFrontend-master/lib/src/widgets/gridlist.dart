import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olx_iit_ropar/apis/category_api.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:provider/provider.dart';

class CategoriesList extends StatelessWidget {
  CategoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoriesP = Provider.of<CategoryProvider>(context);
    final productsP = Provider.of<ProductsProvider>(context);
    final pictureP = Provider.of<PictureProvider>(context);

    return Wrap(
      spacing: 30.0,
      runSpacing: 35.0,
      children: categoriesP.categories.entries.map((entry) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(MediaQuery.of(context).size.width / 4.0,
                MediaQuery.of(context).size.width / 4.0),
            maximumSize: Size(MediaQuery.of(context).size.width / 4.0,
                MediaQuery.of(context).size.width / 4.0),
            padding: EdgeInsets.all(0.0),
            primary: Colors.white,
            elevation: 0.0,
          ),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width/4.0,
                height: MediaQuery.of(context).size.width/6.0,
                child: Ink.image(
                  image: NetworkImage(entry.value.logo),
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.width/6.0,
                  width: MediaQuery.of(context).size.width/4.0,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    entry.value.name,
                    style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          onPressed: () async {
            EasyLoading.show(
              status: 'loading...',
              maskType: EasyLoadingMaskType.black,
            );
            productsP.updateCID(entry.value.id);
            pictureP.updateCID(entry.value.id);
            await productsP.fetchCategoryProducts();
            await pictureP.fetchCategoryImages();
            EasyLoading.dismiss();
            Navigator.pushNamed(context, '/products_screen');
          },
        );
      }).toList(),
    );
  }
}
