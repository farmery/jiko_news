import 'package:flutter/material.dart';
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
  static const _pageSize = 20;
  final Api _api = Api();
  final List<Article> _articles = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final newItems = await _api.getArticles(
        {
          'apiKey': API_KEY,
          'language': 'en',
          'page': _currentPage.toString(),
          'q': widget.category,
          'sortBy': 'publishedAt',
          'pageSize': _pageSize.toString(),
        },
        type: '/v2/everything',
      );

      setState(() {
        _isLoading = false;
        _articles.addAll(newItems);
        _hasMore = newItems.length == _pageSize;
        _currentPage++;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _error = error;
      });
    }
  }

  void _onScroll() {
    if (!_isLoading && _hasMore) {
      final scrollController = PrimaryScrollController.of(context);
      if (scrollController.position.pixels >= 
          scrollController.position.maxScrollExtent * 0.8) {
        _fetchArticles();
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchArticles,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_articles.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          _onScroll();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: _articles.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _articles.length) {
            if (!_isLoading) {
              _fetchArticles();
            }
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return HeadlineItem(
            article: _articles[index],
            onTap: () {},
          );
        },
      ),
    );
  }
}
