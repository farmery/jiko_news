import 'package:flutter/material.dart';
import 'package:jiko_news/pages/discover/category_screen.dart';
import 'package:jiko_news/pages/discover/discover.dart';
import 'package:jiko_news/pages/home/home.dart';
import 'package:jiko_news/pages/home/home_viewmodel.dart';
import 'package:jiko_news/routing/router.dart';
import 'package:provider/provider.dart';

import 'nav_controller.dart';
import 'pages/home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final pages = [
    Discover(),
    ChangeNotifierProvider(create: (_) => HomeViewmodel(), child: Home()),
    Placeholder(),
    Placeholder()
  ];
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NavController())],
      child: MaterialApp(
        onGenerateRoute: generateRoute,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.light(secondary: Color(0xFF0F2534)),
            primaryColor: Colors.white),
        home: Builder(
          builder: (context) {
            final navController = Provider.of<NavController>(context);
            return Scaffold(
              backgroundColor: Colors.grey[100],
              body: pages[navController.activeScreenIndex],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: true,
                showUnselectedLabels: false,
                currentIndex: navController.activeScreenIndex,
                onTap: (index) => navController.navigateToScreen(index),
                selectedItemColor: Theme.of(context).colorScheme.secondary,
                selectedLabelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                unselectedItemColor: Colors.grey,
                items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
              ]),
            );
          }
        ),
      ),
    );
  }
}
