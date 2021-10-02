import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jiko_news/model/article.dart';
import 'package:jiko_news/services/api.dart';
import 'package:jiko_news/services/api_key.dart';
import 'package:provider/provider.dart';

import '../../nav_controller.dart';
import '../../nav_drawer.dart';

class Sources extends StatefulWidget {
  const Sources({Key? key}) : super(key: key);

  @override
  _SourcesState createState() => _SourcesState();
}

class _SourcesState extends State<Sources> {
  late PagingController<int, Article> pagingController;
  final GlobalKey<ScaffoldState> key = GlobalKey();
  Api api = Api();
  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await api.getArticles(
        {
          'apiKey': API_KEY,
          'language': 'en',
          'page': pageKey.toString(),
        },
        type: '/v2/top-headlines',
      );
      final isLastPage = newItems.length < 20;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void initState() {
    super.initState();
    pagingController = PagingController(firstPageKey: 1);

    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    final navController = Provider.of<NavController>(context);

    return SafeArea(
      child: Scaffold(
        key: key,
        drawer: Drawer(
          child: NavDrawer(activeScreenIndex: navController.activeScreenIndex),
        ),
        appBar: AppBar(
            title: Text('Sources'),
            backgroundColor: Theme.of(context).colorScheme.secondary),
        body: Container(
          width: double.infinity,
          child: Expanded(
              child: PagedListView<int, Article>(
                  pagingController: pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Article>(
                      itemBuilder: (_, article, i) => ListTile()))),
        ),
      ),
    );
  }
}
