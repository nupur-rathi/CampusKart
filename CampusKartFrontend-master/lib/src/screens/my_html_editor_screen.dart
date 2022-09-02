// screen to edit the product description
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/widgets/app_bar.dart';
import 'package:olx_iit_ropar/src/widgets/products_body.dart';
import 'package:olx_iit_ropar/src/widgets/search_bar.dart';
import 'package:olx_iit_ropar/src/widgets/upload_product.dart';
import 'package:olx_iit_ropar/src/widgets/my_html_editor.dart';

class HtmlEditorScreen extends StatefulWidget {
  late Function changeProductDescription;
  late String productDescription;

  HtmlEditorScreen(this.changeProductDescription, this.productDescription,
      {Key? key})
      : super(key: key);

  @override
  State<HtmlEditorScreen> createState() =>
      _HtmlEditorScreenState(changeProductDescription, productDescription);
}

class _HtmlEditorScreenState extends State<HtmlEditorScreen> {
  late Function changeProductDescription;
  late String productDescription;

  _HtmlEditorScreenState(
      this.changeProductDescription, this.productDescription);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const TitleBar(),
          MyHtmlEditor(changeProductDescription, productDescription),
        ],
      ),
    );
  }
}
