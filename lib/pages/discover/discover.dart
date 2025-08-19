import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiko_news/nav_controller.dart';
import 'package:jiko_news/nav_drawer.dart';
import 'package:jiko_news/pages/home/search_screen.dart';
import 'package:provider/provider.dart';

import 'category_screen.dart';

class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> with TickerProviderStateMixin {
  late final TabController tabController;

  final List<String> categories = [
    'For You',
    'NBA',
    'Tech',
    'Crypto',
    'Politics',
    'COVID-19',
    ''
  ];
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final navViewModel = Provider.of<NavController>(context);
    final GlobalKey<ScaffoldState> key = GlobalKey();
    return GestureDetector(
      onTap: () {},
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          key: key,
          drawer: Drawer(
            child: NavDrawer(activeScreenIndex: navViewModel.activeScreenIndex),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (_, innerBoxIsScrolled) => [
              SliverAppBar(
                surfaceTintColor: Colors.transparent,
                pinned: true,
                floating: true,
                snap: true,
                actions: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.notifications_outlined, color: Colors.black54)),
                ],
                backgroundColor: Colors.grey[100],
                leading: CupertinoButton(
                  child:
                      Icon(Icons.menu, color: Colors.black87, size: 24),
                  onPressed: () {
                    key.currentState!.openDrawer();
                  },
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(116),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showSearch(context: context, delegate: SearchScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Text('Search', style: TextStyle(color: Colors.black26, fontSize: 14)),
                                      Spacer(),
                                      Icon(Icons.search, color: Colors.black26),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.filter_list, color: Colors.black26),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      TabBar(
                          dividerColor: Colors.transparent,
                          isScrollable: true,
                          indicatorSize: TabBarIndicatorSize.label,
                          tabAlignment: TabAlignment.start,
                          labelColor: Colors.black87,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black38),
                          indicatorColor: Colors.black87,
                          controller: tabController,
                          tabs: categories
                              .map((category) => Tab(text: category))
                              .toList()),
                    ],
                  ),
                ),
              )
            ],
            body: TabBarView(
                controller: tabController,
                children: categories
                    .map((category) => CategoryScreen(category: category))
                    .toList()),
          ),
        ),
      ),
    );
  }
}
