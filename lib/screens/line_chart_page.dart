import 'package:flutter/material.dart';

import 'package:mgflutter/data/line_chart_1.dart';
import 'package:mgflutter/data/line_chart_2.dart';

class LineChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 28,
                right: 28,
              ),
              child: LineChart1(),
            ),
            const SizedBox(
              height: 6,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Income",
                    style: TextStyle(
                        color: Color(0xff4af699),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Expense",
                    style: TextStyle(
                        color: Color(0xff27b6fc),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "P / L",
                    style: TextStyle(
                        color: Color(0xffaa4cfc),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28.0, right: 28),
              child: LineChart2(),
            ),
          ],
        ),
      ),
    );
  }
}
