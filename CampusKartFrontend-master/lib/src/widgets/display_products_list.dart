// Display all the products after filtering or sorting
import 'package:flutter/cupertino.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:olx_iit_ropar/models/product.dart';
import 'package:olx_iit_ropar/models/category.dart';
import 'package:olx_iit_ropar/src/widgets/emptyList.dart';
import 'package:olx_iit_ropar/src/widgets/filter_bar.dart';
import 'package:olx_iit_ropar/src/widgets/product_container.dart';
import 'package:provider/provider.dart';
import 'package:olx_iit_ropar/apis/category_api.dart';

class DisplayProducts extends StatelessWidget {
  Map<dynamic, Product> searchedProducts;
  DisplayProducts(this.searchedProducts, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pictureP = Provider.of<PictureProvider>(context);
    pictureP.fetchAllImages();
    final categoriesP = Provider.of<CategoryProvider>(context, listen: false);

    return Column(
      children: <Widget>[
        Expanded(
          child: searchedProducts.entries.isEmpty
              ? EmptyList()
              : ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: searchedProducts.entries.map<Widget>((entry) {
                    return ProductContainer(
                        entry.value,
                        (categoriesP.categories)[entry.value.category_id]!
                            .name);
                  }).toList(),
                ),
        ),
        const FilterBar(),
      ],
    );
  }
}
