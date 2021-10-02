import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiko_news/model/article.dart';
import 'package:jiko_news/model/source.dart';
import 'package:jiko_news/services/api.dart';
import 'package:jiko_news/services/api_key.dart';

class SearchScreen extends SearchDelegate {
  Future<List<Article>>? queryArticles(String query) async {
    try {
      return Api().getArticles({
        'apiKey': API_KEY,
        'language': 'en',
        'qInTitle': query,
      });
    } catch (e) {
      return Future.value([Article(source: Source())]);
    }
  }

  SearchScreen({
    InputDecorationTheme? searchFieldDecorationTheme,
  }) : super(searchFieldDecorationTheme: searchFieldDecorationTheme);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Article>>(
        future: queryArticles(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final articles = snapshot.data!;
            return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (_, i) =>
                    ListTile(title: Text(articles[i].title!)));
          } else {
            return Container();
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Article>>(
        future: queryArticles(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            final articles = snapshot.data!;
            return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (_, i) => ListTile(
                    minLeadingWidth: 50,
                    leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(articles[i].urlToImage!)))),
                    title: Text(articles[i].title!)));
          } else {
            return Container(
                child: Center(
                    child:
                        Text('Please enter your search in the field above')));
          }
        });
  }
}
