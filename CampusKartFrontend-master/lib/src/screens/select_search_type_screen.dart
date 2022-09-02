import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/src/widgets/app_bar.dart';
import 'package:olx_iit_ropar/src/widgets/constant.dart';
import 'package:olx_iit_ropar/src/screens/search_results_screen.dart';
import 'package:olx_iit_ropar/src/screens/search_by_owner_screen.dart';
import 'package:olx_iit_ropar/utils/constants.dart';

class SelectSearchType extends StatefulWidget {
  @override
  _SelectSearchTypeState createState() => _SelectSearchTypeState();
}

class _SelectSearchTypeState extends State<SelectSearchType> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MaterialButton(
            height: 40.0,
            minWidth: double.infinity,
            color: Color(secondary_color),
            splashColor: Colors.grey,
            child: Row(
              children: const [
                Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                SizedBox(width: 20),
                Text(
                  'Search by Title',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchResult(),
                ),
              );
            },
          ),
          MaterialButton(
            height: 40.0,
            minWidth: double.infinity,
            color: Color(secondary_color),
            splashColor: Colors.grey,
            child: Row(
              children: const [
                Icon(Icons.person_search, color: Colors.white),
                SizedBox(width: 20),
                Text(
                  'Search by Owner',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchResultOwner(),
                ),
              );
            },
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
