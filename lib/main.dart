import 'package:flutter/material.dart';
import 'package:jiko_news/pages/home/home_viewmodel.dart';
import 'package:jiko_news/routing/router.dart';
import 'package:provider/provider.dart';

import 'nav_controller.dart';
import 'pages/home/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NavController())],
      child: MaterialApp(
        onGenerateRoute: generateRoute,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: true,
        theme: ThemeData(
            colorScheme: ColorScheme.light(secondary: Color(0xFF0F2534)),
            primaryColor: Colors.white),
        home: ChangeNotifierProvider(
            create: (_) => HomeViewmodel(), child: Home()),
      ),
    );
  }
}
