import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String text = 'Nama';
  ScrollController controller = ScrollController();

  void onScroll(){
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;

    if(currentScroll == maxScroll){
      //TODO : Implemetasi mengambil data dari api service
    }
  }
  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    controller.addListener(onScroll);

    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Center(
        child: FutureBuilder<NewsListResult>(
          future: NewsListResult.funcGetListNews(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Text("Tidak ada data");
              } else {
                return ListView.builder(
                  controller: controller,
                  itemCount: snapshot.data.listNews.length,
                  itemBuilder: (ctx, i) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CachedNetworkImage(
                          height: mediaQuery.height * 0.25,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          imageUrl: snapshot.data.listNews[i].imageUrl,
                          progressIndicatorBuilder: (ctx, url, downloadProgress) =>
                          new CircularProgressIndicator(
                            value: downloadProgress.progress,
                          ),
                          errorWidget: (ctx, url, error) => new Icon(Icons.error),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              HtmlWidget(
                                snapshot.data.listNews[i].title,
                                bodyPadding: EdgeInsets.all(0),
                                webView: true,
                                textStyle: GoogleFonts.merriweather(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                snapshot.data.listNews[i].description,
                                style: GoogleFonts.openSans(fontSize: 16, height: 1.5),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "-",
                                    style: GoogleFonts.roboto(color: Colors.grey),
                                  ),
                                  Container(
                                    width: mediaQuery.width * 0.5,
                                    alignment: Alignment.centerLeft,
                                    child: FittedBox(
                                      child: FlatButton(
                                        child: HtmlWidget(
                                          "-",
                                          webView: true,
                                          bodyPadding: EdgeInsets.all(0),
                                          textStyle: GoogleFonts.roboto(
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        // onPressed: () => _selectNews(context),
                                        onPressed: () {
                                          //TODO : Implemented function show by category
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          final RenderBox box = context.findRenderObject();

                                        },
                                        child: Icon(Icons.share),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
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
