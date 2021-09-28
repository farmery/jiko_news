import 'dart:convert';
import 'package:jiko_news/model/article.dart';
import 'package:jiko_news/model/source.dart';
import 'package:jiko_news/services/api_key.dart';
import 'package:http/http.dart' as http;

class Api {
  Api._();
  static final instance = Api._();
  factory Api() => instance;

  final endpointUrl = "newsapi.org";
  String apiKey = API_KEY;
  final client = http.Client();

  Future<List<Article>> getArticles(Map<String, dynamic>? queryParameters,
      {String? type}) async {
    final uri = Uri.https(
        endpointUrl, type == null ? '/v2/everything' : type, queryParameters);
    final response = await client.get(uri);
    Map<String, dynamic> json = jsonDecode(response.body);
    List rawArticles = json['articles'];
    List<Article> articles =
        rawArticles.map((article) => Article.fromMap(article)).toList();
    return articles;
  }

  Future<List<Source>> getSources() async {
    final uri = Uri.https(endpointUrl, '/v2/top-headlines/sources');
    final response = await client.get(uri);
    Map<String, dynamic> json = jsonDecode(response.body);
    List rawSources = json['sources'];
    List<Source> sources =
        rawSources.map((source) => Source.fromJson(source)).toList();
    return sources;
  }
}
