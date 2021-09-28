import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jiko_news/model/article.dart';
import 'package:jiko_news/pages/home/headline_item.dart';
import 'package:jiko_news/services/api.dart';
import 'package:jiko_news/services/api_key.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    Key? key,
    required this.category,
  }) : super(key: key);
  final String category;

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final api = Api();
  late PagingController<int, Article> pagingController;
  Future<void> fetchPage(int pageKey) async {
    try {
      final newItems = await api.getArticles(
        {
          'apiKey': API_KEY,
          'language': 'en',
          'page': pageKey.toString(),
          'q': widget.category,
          'sortBy': 'publishedAt'
        },
        type: '/v2/everything',
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
  initState() {
    super.initState();
    pagingController = PagingController(firstPageKey: 1);
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PagedListView<int, Article>(
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (_, article, i) =>
                    HeadlineItem(article: article, onTap: () {}))));
  }
}
