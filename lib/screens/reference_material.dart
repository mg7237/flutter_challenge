import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mgflutter/widgets/content_list.dart';
import 'package:mgflutter/util/constants.dart';
import 'package:mgflutter/util/firebase_content.dart';

class ContentView extends StatefulWidget {
  @override
  _ContentViewState createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  String showBlogOrVideo = "Blogs";
  List<ContentItem> _contentListBlog = [];
  List<ContentItem> _contentListVideos = [];

  @override
  void initState() {
    super.initState();
    _getContentList();
  }

  void _getContentList() async {
    print("wideg");
    var c = ContentList(contentType: "Blogs");
    _contentListBlog = await c.getContentList();
    c = ContentList(contentType: "Videos");
    _contentListVideos = await c.getContentList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Blogs for your reference",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ContentListView(_contentListBlog),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        height: 1.0,
                        width: double.infinity,
                        color: Colors.black12,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Videos for your reference",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ContentListView(_contentListVideos)
                  ],
                ))));
  }
}
