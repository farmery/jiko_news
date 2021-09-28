import 'package:flutter/material.dart';
import 'package:jiko_news/model/article.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';

class NewsDetail extends StatefulWidget {
  const NewsDetail({
    Key? key,
    required this.article,
  }) : super(key: key);
  final Article article;

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: widget.article.url != null
            ? Scaffold(
                appBar: AppBar(
                    title: Text(widget.article.source.name!),
                    backgroundColor: Theme.of(context).colorScheme.secondary),
                body: WebView(
                  initialUrl: widget.article.url,
                ),
              )
            : Container(
                child: Center(
                  child: Text('404'),
                ),
              ));
  }
}
