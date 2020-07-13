import 'package:flutter/material.dart';
import 'package:mgflutter/util/firebase_content.dart';
import 'package:mgflutter/util/constants.dart';

class ContentListItem extends StatelessWidget {
  final ContentItem contentItem;

  ContentListItem({this.contentItem});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          contentItem.displayName,
          style: k_CommonTextStyle,
        ),
        Text(contentItem.URL, style: k_CommonTextStyle),
      ],
    );
  }
}

class ContentListItems extends StatefulWidget {
  final List<ContentItem> itemList;

  ContentListItems({@required this.itemList});

  @override
  _ContentListItemsState createState() => _ContentListItemsState();
}

class _ContentListItemsState extends State<ContentListItems> {
  List<Widget> itemWidgetList = [];

  @override
  Widget build(BuildContext context) {
    itemWidgetList = [];
    print("init--- ${widget.itemList.length}");

    for (int i = 0; i < widget.itemList.length; i++) {
      Widget itemWidget;
      print("Loop ${widget.itemList[i].displayName}");
      itemWidget = Row(
        children: [
          Text(
            widget.itemList[i].displayName,
            style: k_CommonTextStyle,
          ),
          Text(widget.itemList[i].URL)
        ],
      );
      itemWidgetList.add(itemWidget);
    }
    return Container(
      child: (itemWidgetList == null)
          ? Text("Empty")
          : Column(
              children: itemWidgetList,
            ),
    );
  }
}
