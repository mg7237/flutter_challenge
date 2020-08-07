import 'package:flutter/material.dart';

import 'package:mgflutter/data/pie_chart_sample1.dart';
import 'package:mgflutter/data/pie_chart_sample2.dart';

class PieChartPage extends StatelessWidget {
  final Color barColor = Colors.white;
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final double width = 22;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: ListView(
            children: <Widget>[
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Expense Breakup',
                    style: TextStyle(
                        color: Color(
                          0xff333333,
                        ),
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              PieChartSample1(),
              const SizedBox(
                height: 12,
              ),
              PieChartSample2(),
            ],
          ),
        ),
      ),
    );
  }
}
