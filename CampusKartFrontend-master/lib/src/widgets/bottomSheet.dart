// Bottom sheet for filtering and sorting the products
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:olx_iit_ropar/src/widgets/round_button.dart';
import 'package:provider/provider.dart';

class MyBottomSheet extends StatefulWidget {
  final whichBS;

  const MyBottomSheet(this.whichBS);

  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  bool isCheckedY = false;
  bool isCheckedN = false;

  // Widget for showing bottom bar for sorting based on date uploaded and price
  Widget _buildSortBS(context) {
    final productsP = Provider.of<ProductsProvider>(context);

    // Function for fetching sorted products
    sort(var input) async {
      EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );
      await productsP.fetchSortProducts(input);
      EasyLoading.dismiss();
    }

    return Wrap(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.only(
              left: 30.0, right: 30.0, top: 10.0, bottom: 0.0),
          title: InkWell(
            onTap: () async {
              sort('date');
              Navigator.pop(context);
            },
            child: const Text("Date uploaded"),
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.only(
              left: 30.0, right: 30.0, top: 0.0, bottom: 0.0),
          title: InkWell(
            onTap: () async {
              sort('LowToHigh');
              Navigator.pop(context);
            },
            child: const Text("Price: Low to High"),
          ),
        ),
        ListTile(
          contentPadding: const EdgeInsets.only(
              left: 30.0, right: 30.0, top: 0.0, bottom: 10.0),
          title: InkWell(
            onTap: () async {
              sort('HighToLow');
              Navigator.pop(context);
            },
            child: const Text("Price: High to Low"),
          ),
        ),
      ],
    );
  }

  double _currentMySliderValue = 20;

  // Building the slider for price filtering
  Widget _buildMySlider() {
    return Slider(
      value: _currentMySliderValue,
      max: 10000,
      divisions: 100,
      label: (_currentMySliderValue == 10000)
          ? _currentMySliderValue.round().toString() + " and above"
          : _currentMySliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentMySliderValue = value;
        });
      },
    );
  }

  // Filtering based on price and negotiation status
  Widget _buildFilterBS(context) {
    final productsP = Provider.of<ProductsProvider>(context);

    // Function to filter the products
    filter(double input) async {
      EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );
      await productsP.fetchFilterProducts(
          input.toInt(), isCheckedY, isCheckedN);
      EasyLoading.dismiss();
    }

    return Wrap(
      children: [
        const ListTile(title: Text("Price Range:")),
        _buildMySlider(),
        const ListTile(title: Text("Open to negotiation:")),
        Row(
          children: [
            Checkbox(
              value: isCheckedY,
              onChanged: (bool? value) {
                setState(() {
                  isCheckedY = value!;
                });
              },
            ),
            const Text("Yes"),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: isCheckedN,
              onChanged: (bool? value) {
                setState(() {
                  isCheckedN = value!;
                });
              },
            ),
            const Text("No"),
          ],
        ),
        ListTile(
          title: ElevatedButton(
              child: const Text("Apply"),
              onPressed: () async {
                filter(_currentMySliderValue);
                Navigator.pop(context);
              }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.whichBS == "sort") {
      return _buildSortBS(context);
    } else if (widget.whichBS == "filter") {
      return _buildFilterBS(context);
    } else {
      return Container();
    }
  }
}
