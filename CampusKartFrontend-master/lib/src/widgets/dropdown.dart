// Dropdown for choosing category in upload product
import 'package:flutter/material.dart';

class Dropdown extends StatefulWidget {
  final List<String> items;
  String dropDownValue;
  final Function productType;

  Dropdown(this.dropDownValue, this.items, this.productType);

  @override
  _DropdownState createState() => _DropdownState(dropDownValue);
}

class _DropdownState extends State<Dropdown> {
  var dropDownValue;

  _DropdownState(this.dropDownValue);

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: dropDownValue,
      icon: const Icon(Icons.expand_more),
      iconSize: 20,
      elevation: 16,
      isExpanded: true,
      style: const TextStyle(color: Color(0xFF616161), fontSize: 18.0),
      underline: Container(
        height: 1,
        color: Colors.grey,
      ),
      onChanged: (var newValue) {
        setState(() {
          dropDownValue = newValue.toString();
        });
        widget.productType(newValue.toString());
      },
      items: widget.items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
