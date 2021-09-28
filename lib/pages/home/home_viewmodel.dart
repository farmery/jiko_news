import 'package:flutter/cupertino.dart';
import 'package:jiko_news/model/article.dart';
import 'package:jiko_news/utils/stack.dart' as stack;

class HomeViewmodel with ChangeNotifier {
  var recentArticles = stack.Stack<Article>();

  Article? get mostRecentArticle =>
      !recentArticles.isEmpty ? recentArticles.top : null;

  addArticle(Article article) {
    if (recentArticles.length < 10) {
      recentArticles.push(article);
    } else {
      recentArticles.pop();
      recentArticles.push(article);
    }
    notifyListeners();
  }
}
