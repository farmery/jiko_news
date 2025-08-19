import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiko_news/model/article.dart';
import 'package:jiko_news/pages/home/home_viewmodel.dart';
import 'package:jiko_news/pages/home/headline_item.dart';
import 'package:jiko_news/pages/home/search_screen.dart';
import 'package:jiko_news/services/api.dart';
import 'package:jiko_news/services/api_key.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  final Api _api = Api();
  final List<Article> _articles = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  Object? _error;

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
        },
        type: '/v2/top-headlines',
      );

      setState(() {
        _isLoading = false;
        _articles.addAll(newItems);
        _hasMore = newItems.length == 20; // Assuming 20 items per page
        _currentPage++;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _error = error;
      });
    }
  }

  Future<List<Article>?> queryArticles(String query) async {
    try {
      return await _api.getArticles(
        {
          'apiKey': API_KEY,
          'language': 'en',
          'q': query,
        },
        type: '/v2/top-headlines',
      );
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewmodel>(context);
    final mostRecentArticle = viewModel.mostRecentArticle;
    bool isRecentStackEmpty = viewModel.recentArticles.isEmpty;

    if (_error != null) {
      return Scaffold(
        body: Center(
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
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        key: key,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black.withOpacity(0.8),
              pinned: true,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                CupertinoButton(
                  child: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    showSearch(context: context, delegate: SearchScreen());
                  },
                )
              ],
              leading: CupertinoButton(
                onPressed: () {
                  if (!key.currentState!.isDrawerOpen) {
                    key.currentState!.openDrawer();
                  }
                },
                child: const Icon(Icons.menu, color: Colors.white),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: !isRecentStackEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: const ColorFilter.srgbToLinearGamma(),
                            image: NetworkImage(
                                mostRecentArticle!.urlToImage ?? ''),
                          ),
                        ),
                      )
                    : Container(
                        height: 250,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary)),
                title: Text(
                  !isRecentStackEmpty
                      ? 'Continue Reading...${mostRecentArticle!.title!}'
                      : 'Jiko News',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              expandedHeight: 300,
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Headlines',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
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
                    onTap: () {
                      viewModel.addArticle(_articles[index]);
                    },
                  );
                },
                childCount: _articles.length + (_hasMore ? 1 : 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
