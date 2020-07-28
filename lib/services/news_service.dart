import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;

import '../models/news_model.dart';

class NewsListResult{
  List<News> listNews;

  NewsListResult({
    this.listNews
  });

  factory NewsListResult.getListResult(NewsListResult data) {
    return NewsListResult(listNews: data.listNews);
  }

  static Future<NewsListResult> funcGetListNews() async{
    String url = "https://apikid.kompas.id/v2/article/list/terms?&siteid=1&timestamp=2020-07-28 00:00:00";
    String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9hcGlnZW4ua29tcGFzLmlkIiwiaWF0IjoxNTk1OTMzMDE5LCJleHAiOjE1OTU5MzM5MTksImRhdGEiOnsiaWQiOiI0YzdiOWNmMC0zYTg5LTQwNGYtOGZmOC0xM2FlZGMxN2NlOGQiLCJlbWFpbCI6ImFub255bm91cy51c2VyQGtvbXBhcy5pZCIsInJvbGUiOlsic3Vic2NyaWJlciJdfX0.fBvRFCyTLUZR3h7S7IOsa2hI5RIJexucoN0WK5STKpexkpOGk5k7ns3SQZLbWsK2C99QrGYURV8E7NgMqoqepclzG3YVTtynD3wSRU_QO-Uhlh4YUXKaGHO1hJaur082k-unh0SOvKZtb-hC3G4W9OTV_-ZltLjBpYEJwTNJS_U";
    List<News> news = [];

    final response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token});

    var responseJson = json.decode(response.body);
    print(responseJson);

    List<News> temp = [];

    try{
      for (var i in responseJson['result']['articles']) {
        News getListNews = News(
          postName: i['name'],
          title: i['title'],
          description: i['excerpt'],
          imageUrl: i['thumbnails']['sizes']['thumbnail_medium']['permalink'],
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