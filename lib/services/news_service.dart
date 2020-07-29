import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../models/news_model.dart';

class NewsListResult {
  List<News> listNews;
  String cursor;

  NewsListResult({this.listNews, this.cursor});

  factory NewsListResult.getListResult(NewsListResult data) {
    return NewsListResult(
      listNews: data.listNews,
      cursor: data.cursor,
    );
  }

  static Future<NewsListResult> funcGetListNews(String cursor) async {
    String url;
    if (cursor == null) {
      url =
          "https://apikid.kompas.id/v2/article/list/terms?&siteid=1&timestamp=2020-07-28 00:00:00";
    } else {
      url =
          "https://apikid.kompas.id/v2/article/list/terms?&siteid=1&timestamp=2020-07-28 00:00:00&cursor=" +
              cursor;
    }

    String token =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9hcGlnZW4ua29tcGFzLmlkIiwiaWF0IjoxNTk2MDA5ODM1LCJleHAiOjE1OTYwMTA3MzUsImRhdGEiOnsiaWQiOiI5YmQyNTZhZi0yNzI3LTQzMWMtYTZkZS01NDg4M2YxNmNjMjgiLCJlbWFpbCI6Im1hZGUud2FoeXVAa29tcGFzLmNvbSIsInJvbGUiOlsic3Vic2NyaWJlciJdfX0.QeGINhxg_aYv8Ez50uY2p-K2HxhRWcCyhomndHUn7-hCxwlzpPd2kw5yIXxJbnTVYtnrx9VuypiypIxFcBmWES1-EoimU3fgw5jXV2FybK2o52WP5B48LIwB6SiD2xsz6la1nFg4GSdHm2bvIv6v5VN0h5YlynXCrsI52wd3HiI";

    List<News> news = [];

    final response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token});

    var responseJson = json.decode(response.body);
    print(responseJson);

    List<News> temp = [];

    try {
      for (var i in responseJson['result']['articles']) {
        News getListNews = News(
          postName: i['name'],
          title: i['title'],
          description: i['excerpt'],
          imageUrl: i['thumbnails']['sizes']['thumbnail_medium']['permalink'],
        );
        temp.add(getListNews);
        cursor = responseJson['result']['meta']['next'];
      }
    } catch (e) {
      print('Error occurs: $e');
    }
    news.addAll(temp);

    NewsListResult contentResult = new NewsListResult(
      listNews: news,
      cursor: cursor,
    );

    return NewsListResult.getListResult(contentResult);
  }
}
