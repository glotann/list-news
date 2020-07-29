import 'package:flutter/material.dart';
import 'package:list_view_kompas/models/news_model.dart';
import 'package:list_view_kompas/screens/news_screen.dart';
import 'package:list_view_kompas/services/news_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Testing list view',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String cursor;
  List<News> news = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Center(
        child: FutureBuilder<NewsListResult>(
          future: NewsListResult.funcGetListNews(cursor),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text("Error");
              } else {
                news.addAll(snapshot.data.listNews);
                cursor = snapshot.data.cursor;
                return ListViewItem(news,cursor);
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
