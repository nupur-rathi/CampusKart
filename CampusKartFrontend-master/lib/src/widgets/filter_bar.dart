// The widget showing the options if the user wants to filter or to sort
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/widgets/bottomSheet.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({Key? key}) : super(key: key);

  @override
  _FilterBarState createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  String whichBS = "";

  void setBS(var input) {
    setState(() {
      whichBS = input;
    });
  }

  @override
  Widget build(BuildContext context) {
    _bottomSheet(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext c) {
            return MyBottomSheet(whichBS);
          });
    }

    return Container(
      width: double.infinity,
      height: 45,
      padding:
          const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFF616161),
            width: 0.1,
          ),
          bottom: BorderSide(
            color: Color(0xFF616161),
            width: 0.06,
          ),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 15.0,
        children: <Widget>[
          TextButton.icon(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0)),
              textStyle: MaterialStateProperty.all<TextStyle?>(const TextStyle(
                fontSize: 15,
              )),
              foregroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF616161)),
            ),
            label: const Text('Filter'),
            icon: const Icon(Icons.filter_alt, size: 18.0),
            onPressed: () {
              setBS("filter");
              _bottomSheet(context);
            },
          ),
          TextButton.icon(
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0)),
              textStyle: MaterialStateProperty.all<TextStyle?>(const TextStyle(
                fontSize: 15,
              )),
              foregroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFF616161)),
            ),
            label: const Text('Sort'),
            icon: const Icon(Icons.sync_alt, size: 18.0),
            onPressed: () {
              setBS("sort");
              _bottomSheet(context);
            },
          ),
        ],
      ),
    );
  }
}
