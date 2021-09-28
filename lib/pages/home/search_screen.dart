import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      CupertinoButton(
        child: Icon(Icons.clear),
        onPressed: () {},
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return CupertinoButton(child: Icon(Icons.arrow_back_ios), onPressed: () {});
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
