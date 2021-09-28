import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiko_news/model/article.dart';
import 'package:jiko_news/pages/discover/discover.dart';
import 'package:jiko_news/pages/home/home.dart';
import 'package:jiko_news/pages/home/home_viewmodel.dart';
import 'package:jiko_news/pages/news_detail/news_detail.dart';
import 'package:provider/provider.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case 'home':
      return CupertinoPageRoute(
          builder: (_) => ChangeNotifierProvider(
              create: (_) => HomeViewmodel(), child: Home()));
    case 'discover':
      return CupertinoPageRoute(builder: (_) => Discover());
    case 'news_detail':
      return CupertinoPageRoute(
          builder: (_) => NewsDetail(article: settings.arguments as Article));
    default:
      return CupertinoPageRoute(builder: (_) => Home());
  }
}
