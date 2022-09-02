// The top search bar widget
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:olx_iit_ropar/utils/constants.dart';
import 'package:olx_iit_ropar/src/screens/search_results_screen.dart';
import 'package:olx_iit_ropar/src/screens/select_search_type_screen.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SelectSearchType();
          },
        );
      },
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(primary_color),
        ),
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width / 1.1,
          height: 38,
          color: Colors.white,
          child: Center(
            child: IgnorePointer(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for products and more...',
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchResult(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
