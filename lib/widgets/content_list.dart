import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mgflutter/util/firebase_content.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ContentListView extends StatefulWidget {
  final List<ContentItem> contentList;
  ContentListView(this.contentList);

  @override
  _ContentListViewState createState() => _ContentListViewState();
}

class _ContentListViewState extends State<ContentListView> {
  String displayText = "";
  List<Widget> _contentBlocks = [];
  List<ContentItem> _contentList = [];

  @override
  void initState() {
    super.initState();
  }

  void _getContentBlocks() {
    _contentList = widget.contentList;

    int i;
    for (i = 0; i < _contentList.length; i++) {
      Widget item = Container(
        width: MediaQuery.of(context).size.width - 75,
        height: 275,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          //borderRadius: BorderRadius.circular(10),
        ),
        child: Card(
          elevation: 10,
          child: Column(
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(_contentList[i].imageURL),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10.0),
                    topRight: const Radius.circular(10.0),
                  ),
                ),
              ),
              Container(height: 75, child: Text(_contentList[i].displayName))
            ],
          ),
        ),
      );
      _contentBlocks.add(item);
    }
    print("BEDO " + _contentBlocks.length.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _getContentBlocks();
    _contentList = widget.contentList;
    return Container(
        height: (MediaQuery.of(context).size.height / 2) - 80,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ((_contentList == null || _contentList.length == 0)
            ? Text("No Data")
            : ListView.builder(
                itemCount: _contentBlocks.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return _contentBlocks[index];
                },
              )));
  }
}
