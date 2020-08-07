import 'package:flutter/material.dart';
import 'package:mgflutter/data/bar_chart_sample1.dart';
import 'package:mgflutter/data/bar_chart_sample2.dart';

class BarChartPage extends StatefulWidget {
  @override
  _BarChartPageState createState() => _BarChartPageState();
}

class _BarChartPageState extends State<BarChartPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 32),
              child: BarChartSample1(),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: BarChartSample2(),
            ),
          )
        ],
      )),
    );
  }
}
