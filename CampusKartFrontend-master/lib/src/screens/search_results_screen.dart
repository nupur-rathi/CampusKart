// Keeps a list of all the search results
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:olx_iit_ropar/models/category.dart';
import 'package:olx_iit_ropar/src/widgets/product_container.dart';
import 'package:olx_iit_ropar/utils/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:olx_iit_ropar/apis/category_api.dart';
import 'package:olx_iit_ropar/apis/image_api.dart';
import 'package:olx_iit_ropar/apis/product_api.dart';
import 'package:provider/provider.dart';
import 'package:olx_iit_ropar/models/product.dart';
import 'package:olx_iit_ropar/models/category.dart';
import 'package:olx_iit_ropar/src/widgets/filter_bar.dart';
import 'package:olx_iit_ropar/src/widgets/display_products_list.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  static const historyLength = 5;
  List<String> _searchHistory = [];

  List<String> filteredSearchHistory = [];

  String selectedTerm = '';

  List<String> filterSearchTerms(String? filter) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((element) => element.startsWith(filter))
          .toList();
    }
    return _searchHistory.reversed.toList();
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((element) => element == term);
    filteredSearchHistory = filterSearchTerms(null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  late FloatingSearchBarController controller = FloatingSearchBarController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final productsP = Provider.of<ProductsProvider>(context);
    Map<dynamic, Product> searchedProducts = productsP.products;

    return Scaffold(
      body: FloatingSearchBar(
        backdropColor: Colors.black26,
        physics: const BouncingScrollPhysics(),
        title: Text(selectedTerm),
        hint: 'search products here...',
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        controller: controller,
        body: RefreshIndicator(
          onRefresh: () async {
            await productsP.fetchSearchProducts(selectedTerm);
            setState(() {
              searchedProducts = productsP.products;
            });
          },
          child: SearchBarsListView(selectedTerm, searchedProducts),
        ),
        onQueryChanged: (query) {
          setState(() {
            filteredSearchHistory = filterSearchTerms(query);
          });
        },
        onSubmitted: (query) async {
          await productsP.fetchSearchProducts(query);
          addSearchTerm(query);
          setState(() {
            selectedTerm = query;
            searchedProducts = productsP.products;
          });
          controller.close();
        },
        transitionDuration: const Duration(milliseconds: 800),
        transitionCurve: Curves.easeInOut,
        debounceDelay: const Duration(milliseconds: 500),
        transition: CircularFloatingSearchBarTransition(),
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(
                builder: (BuildContext context) {
                  if (filteredSearchHistory.isEmpty &&
                      controller.query.isEmpty) {
                    return Container(
                      height: 50,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Start searching',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    );
                  } else if (filteredSearchHistory.isEmpty) {
                    return ListTile(
                      title: Text(controller.query),
                      leading: const Icon(Icons.search),
                      onTap: () {
                        setState(() {
                          addSearchTerm(controller.query);
                          selectedTerm = controller.query;
                        });
                        controller.close();
                      },
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: filteredSearchHistory
                          .map((term) => ListTile(
                                title: Text(
                                  term,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: const Icon(Icons.history),
                                trailing: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      deleteSearchTerm(term);
                                    });
                                  },
                                ),
                                onTap: () async {
                                  await productsP.fetchSearchProducts(term);
                                  putSearchTermFirst(term);
                                  setState(() {
                                    selectedTerm = term;
                                  });
                                  controller.close();
                                },
                              ))
                          .toList(),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchBarsListView extends StatelessWidget {
  String searchTerm;
  Map<dynamic, Product> searchedProducts;

  SearchBarsListView(this.searchTerm, this.searchedProducts);

  @override
  Widget build(BuildContext context) {
    final fsb = FloatingSearchBar.of(context);

    return Container(
      padding: const EdgeInsets.only(top: 100),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      alignment: Alignment.center,
      child: DisplayProducts(searchedProducts),
    );
  }
}
