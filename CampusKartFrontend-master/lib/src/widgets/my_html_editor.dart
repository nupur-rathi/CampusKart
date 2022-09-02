// The HTML editor for writing the description in a customized way
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import '../../utils/constants.dart';

class MyHtmlEditor extends StatefulWidget {
  late Function changeProductDescription;
  late String productDescription;

  MyHtmlEditor(this.changeProductDescription, this.productDescription);

  @override
  _MyHtmlEditorState createState() =>
      _MyHtmlEditorState(changeProductDescription, productDescription);
}

class _MyHtmlEditorState extends State<MyHtmlEditor> {
  late Function changeProductDescription;
  late String productDescription;

  _MyHtmlEditorState(this.changeProductDescription, this.productDescription);

  @override
  Widget build(BuildContext context) {
    HtmlEditorController controller = HtmlEditorController();
    return Expanded(
        child: ListView(
      scrollDirection: Axis.vertical,
      children: [
        HtmlEditor(
          controller: controller, //required
          hint: "Your text here...",
          initialText: productDescription,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: MaterialButton(
            height: 40.0,
            minWidth: MediaQuery.of(context).size.width / 1.1,
            color: Color(primary_color),
            splashColor: const Color(0xff2CA4FF),
            onPressed: () async {
              String? text = await controller.getText();
              changeProductDescription(text);
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    ));
  }
}
