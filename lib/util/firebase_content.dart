import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ContentItem {
  String displayName;
  String URL;
  String imageURL;
  ContentItem({this.displayName, this.URL, this.imageURL});
}

class ContentList {
  final String contentType;
  ContentList({@required this.contentType});

  List<ContentItem> _contentList = [];

  Future<List<ContentItem>> getContentList() async {
    final _firestore = Firestore.instance;
    final _contentCollection = _firestore.collection(contentType);

    try {
      var documentList = (await _contentCollection.getDocuments()).documents;

      if (documentList.length == 0) {
        return null;
      } else {
        for (int i = 0; i < documentList.length; i++) {
          Map d = documentList[i].data;

          String displayName;
          String url;
          String imageURL;

          d.forEach((key, value) {
            if (key == "DisplayName") {
              displayName = value;
            } else if (key == "URL") {
              url = value;
            } else if (key == 'imageURL') {
              imageURL = value;
            }
          });
          print("displayName $displayName");
          print("URL $url");
          print("imageURL $imageURL");
          ContentItem item = ContentItem(
              displayName: displayName, URL: url, imageURL: imageURL);
          _contentList.add(item);
        }
      }

      //print("documentList[i].data ${documentList[i].data}");

    } catch (e) {
      print(e.toString());
    }
    return _contentList;
  }
}
