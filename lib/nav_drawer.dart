import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiko_news/routing/routing_constants.dart';
import 'package:provider/provider.dart';

import 'nav_controller.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({
    Key? key,
    required this.activeScreenIndex,
  }) : super(key: key);
  final int activeScreenIndex;
  @override
  Widget build(BuildContext context) {
    List titles = [
      ['Home', CupertinoIcons.home],
      ['Discover', CupertinoIcons.search],
      ['Sources', CupertinoIcons.news],
    ];
    final navController = Provider.of<NavController>(context, listen: false);
    return Container(
      child: Column(
        children: List.generate(
          titles.length,
          (index) => InkWell(
            onTap: activeScreenIndex == index
                ? () {
                    Navigator.pop(context);
                  }
                : () {
                    navController.navigateToScreen(index);
                    if (index == 0) {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, Home);
                    } else if (index == 1) {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, Discover);
                    } else if (index == 2) {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, Sources);
                    }
                  },
            child: ListTile(
              leading: Icon(titles[index][1],
                  color:
                      activeScreenIndex == index ? Colors.white : Colors.grey),
              tileColor: activeScreenIndex == index
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.transparent,
              title: Text(titles[index][0],
                  style: activeScreenIndex == index
                      ? TextStyle(color: Colors.white, fontSize: 20)
                      : Theme.of(context).textTheme.headline6),
            ),
          ),
        ),
      ),
    );
  }
}
