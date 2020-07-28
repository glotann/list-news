import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/news_model.dart';

class NewsListResult{
  List<News> listNews;

  NewsListResult({
    this.listNews
  });

  factory NewsListResult.getListResult(NewsListResult data) {
    return NewsListResult(listNews: data.listNews);
  }

  static Future<void> funcGetListNews() async{
    String url = "https://apikid.kompas.id/v2/article/list/terms?&siteid=1&timestamp=2020-07-28 00:00:00";
    String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9hcGlnZW4ua29tcGFzLmlkIiwiaWF0IjoxNTk1OTIyMjQyLCJleHAiOjE1OTU5MjMxNDIsImRhdGEiOnsiaWQiOiI0YzdiOWNmMC0zYTg5LTQwNGYtOGZmOC0xM2FlZGMxN2NlOGQiLCJlbWFpbCI6ImFub255bm91cy51c2VyQGtvbXBhcy5pZCIsInJvbGUiOlsic3Vic2NyaWJlciJdfX0.xtVL79MZS5No8UtxLI3yv1swVWtlocdY6UCqZZcQAKK6_ejckzE5kQaZljpZFjdFgGbO8rhjZsyW27g8x64V5wLfywdaFKKNlUMJqBqHsOj4M6nmz4gyh4-6tNhwI6XSXB8L8pGAF014Q3I1B4bjn1aCfCMmPJIGMaF6mO2wGeo";
    List<News> news = [];

    final response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token});

    var responseJson = json.decode(response.body);

    List<News> temp = [];

    try{
      for (var i in responseJson['result']['articles']) {
        News getListNews = News(
          postName: i['name'],
          title: i['title'],
          description: i['excerpt'],
        );
        temp.add(getListNews);
      }
    }
    catch(e){
      print('Error occurs: $e');
    }
    news.addAll(temp);

    NewsListResult contentResult = new NewsListResult(listNews: news);

    return NewsListResult.getListResult(contentResult);
  }

}