import 'package:flutter/material.dart';
import 'package:mgflutter/util/constants.dart';

const owl_url =
    'https://raw.githubusercontent.com/flutter/website/master/src/images/owl.jpg';

class FadeInDemo extends StatefulWidget {
  _FadeInDemoState createState() => _FadeInDemoState();
}

class _FadeInDemoState extends State<FadeInDemo> {
  double opacity = 0.0;
  String btnLabel = "Click to Fade In";
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(children: <Widget>[
        Image.network(owl_url),
        MaterialButton(
            child: Text(
              btnLabel,
              style: TextStyle(color: Colors.blueAccent, fontSize: 24),
            ),
            onPressed: () {
              setState(() {
                if (btnLabel == "Click to Fade In") {
                  opacity = 1.0;
                  btnLabel = "Click to Fade Out";
                } else {
                  opacity = 0;
                  btnLabel = "Click to Fade In";
                }
              });
            }),
        AnimatedOpacity(
          duration: Duration(seconds: 2),
          opacity: opacity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Text(
                'Type: Owl',
                style: k_LabelTextStyle,
              ),
              SizedBox(height: 10),
              Text(
                'Age: 39',
                style: k_LabelTextStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Name: Dangerous',
                style: k_LabelTextStyle,
              ),
            ],
          ),
        )
      ]),
    );
  }
}
