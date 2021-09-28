import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiko_news/model/article.dart';
import 'package:jiko_news/routing/routing_constants.dart';

class HeadlineItem extends StatelessWidget {
  const HeadlineItem({Key? key, required this.article, required this.onTap})
      : super(key: key);
  final Article article;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
        Navigator.of(context).pushNamed(NewsDetail, arguments: article);
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              article.urlToImage == null
                  ? Container(
                      height: 250,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/news_art.jpg'))))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(article.urlToImage.toString()),
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                height: 8,
              ),
              Text(
                article.title!,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormat('hh:mm , dd MMMM')
                      .format(DateTime.parse(article.publishedAt!)),
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
