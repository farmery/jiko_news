import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiko_news/nav_controller.dart';
import 'package:jiko_news/nav_drawer.dart';
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
    'Football',
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
          key: key,
          drawer: Drawer(
            child: NavDrawer(activeScreenIndex: navViewModel.activeScreenIndex),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (_, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                floating: true,
                snap: true,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                title: Text('Discover', style: TextStyle(color: Colors.white)),
                leading: CupertinoButton(
                  child:
                      Icon(Icons.menu, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    key.currentState!.openDrawer();
                  },
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(48),
                  child: Theme(
                    data: ThemeData.dark(),
                    child: TabBar(
                        isScrollable: true,
                        controller: tabController,
                        tabs: categories
                            .map((category) => Tab(text: category))
                            .toList()),
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
