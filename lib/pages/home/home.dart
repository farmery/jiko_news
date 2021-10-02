import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:jiko_news/model/article.dart';
import 'package:jiko_news/pages/home/home_viewmodel.dart';
import 'package:jiko_news/services/api.dart';
import 'package:jiko_news/services/api_key.dart';
import 'package:provider/provider.dart';
import '../../nav_controller.dart';
import '../../nav_drawer.dart';
import 'headline_item.dart';
import 'search_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  final api = Api();
  late PagingController<int, Article> pagingController;
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

  Future<List<Article>?> queryArticles(String query) async {
    try {
      api.getArticles({
        'apiKey': API_KEY,
        'language': 'en',
        'q': query,
      }, type: '/v2/top-headlines');
    } catch (e) {
      print(e.toString);
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
    final viewModel = Provider.of<HomeViewmodel>(context);
    final mostRecentArticle = viewModel.mostRecentArticle;
    bool isRecentStackEmpty = viewModel.recentArticles.isEmpty;
    return SafeArea(
      child: Scaffold(
        key: key,
        drawer: Drawer(
          child: NavDrawer(activeScreenIndex: navController.activeScreenIndex),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.black.withOpacity(0.8),
              pinned: true,
              iconTheme: IconThemeData(color: Colors.white),
              actions: [
                CupertinoButton(
                  child: Icon(Icons.search, color: Colors.white),
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
                child: Icon(Icons.menu, color: Colors.white),
              ),
              flexibleSpace: FlexibleSpaceBar(
                  background: !isRecentStackEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.srgbToLinearGamma(),
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
                        ? 'Continue Reading...' + mostRecentArticle!.title!
                        : 'Jiko News',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
              expandedHeight: 300,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Headlines',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            PagedSliverList<int, Article>(
              pagingController: pagingController,
              builderDelegate: PagedChildBuilderDelegate<Article>(
                  itemBuilder: (_, article, i) => HeadlineItem(
                        article: article,
                        onTap: () {
                          viewModel.addArticle(article);
                        },
                      )),
            )
          ],
        ),
      ),
    );
  }
}
