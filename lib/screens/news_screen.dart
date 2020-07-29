import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:list_view_kompas/models/news_model.dart';
import 'package:list_view_kompas/services/news_service.dart';

class ListViewItem extends StatefulWidget {
  final List<News> news;
  final String cursor;
  ListViewItem(this.news, this.cursor);
  _ListViewItemState createState() => _ListViewItemState();
}

class _ListViewItemState extends State<ListViewItem> {
  String cursor;
  ScrollController controller = ScrollController();
  List<News> data = [];

  @override
  void initState() {
    super.initState();
    data = widget.news;
    cursor = widget.cursor;
  }

  void onScroll() async {
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;

    if (currentScroll == maxScroll) {
      //TODO : Implemetasi mengambil data dari api service

      var temp = await NewsListResult.funcGetListNews(cursor);
      data.addAll(temp.listNews);

      setState(() {
        cursor = temp.cursor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    controller.addListener(onScroll);
    return ListView.builder(
      controller: controller,
      itemCount: data.length + 1,
      itemBuilder: (ctx, i) => (i < data.length)
          ? buildItem(mediaQuery, data, i, context)
          : Container(
              child: Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
    );
  }

  Column buildItem(
      Size mediaQuery, List<News> snapshot, int i, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CachedNetworkImage(
          height: mediaQuery.height * 0.25,
          width: double.infinity,
          fit: BoxFit.cover,
          imageUrl: snapshot[i].imageUrl,
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
                snapshot[i].title,
                bodyPadding: EdgeInsets.all(0),
                webView: true,
                textStyle: GoogleFonts.merriweather(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                snapshot[i].description,
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
                        onTap: () {},
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
  }
}
