import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mgflutter/screens/progress_indicators.dart';
import 'package:mgflutter/util/constants.dart';
import 'package:mgflutter/screens/line_chart_page.dart';
import 'package:mgflutter/screens/bar_chart_page.dart';
import 'package:mgflutter/screens/pie_chart_page.dart';
import 'package:mgflutter/screens/scatter_chart_page.dart';
import 'package:mgflutter/screens/implicit_animation.dart';

class ChallengesStart extends StatefulWidget {
  @override
  _ChallengesStartState createState() => _ChallengesStartState();
}

class _ChallengesStartState extends State<ChallengesStart> {
  bool animationsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(title: Text("Challenges List View")),
        body: ListView(
          children: [
            Card(
              elevation: 10,
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.spinner,
                  color: Colors.red,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                ),
                title: Text(
                  "Animations - Progress Bars",
                  style: k_CommonTextStyle,
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProgressIndicators())),
              ),
            ),
            Card(
              elevation: 10,
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.random,
                  color: Colors.red,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                ),
                title: Text(
                  "Animations - Fade In (Simple Implicit)",
                  style: k_CommonTextStyle,
                ),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FadeInDemo())),
              ),
            ),
            Card(
              elevation: 10,
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.chartLine,
                  color: Colors.red,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                ),
                title: Text(
                  "Dashboard - Line Charts",
                  style: k_CommonTextStyle,
                ),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LineChartPage())),
              ),
            ),
            Card(
              elevation: 10,
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.chartBar,
                  color: Colors.red,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                ),
                title: Text(
                  "Dashboard - Bar Charts",
                  style: k_CommonTextStyle,
                ),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BarChartPage())),
              ),
            ),
            Card(
              elevation: 10,
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.chartPie,
                  color: Colors.red,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: 18,
                ),
                title: Text(
                  "Dashboard - Pie Charts",
                  style: k_CommonTextStyle,
                ),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PieChartPage())),
              ),
            ),
            Card(
              elevation: 10,
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.chartArea,
                  color: Colors.red,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  size: 18,
                ),
                title: Text(
                  "Dashboard - Scatter Charts",
                  style: k_CommonTextStyle,
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ScatterChartPage())),
              ),
            )
          ],
        ),
      ),
    );
  }
}
