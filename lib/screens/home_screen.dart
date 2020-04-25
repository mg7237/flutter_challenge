import 'package:flutter/material.dart';
import 'package:mgflutter/screens/challenges_home.dart';
import 'package:mgflutter/util/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('F L U T T E R --- W E L C O M E'),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: k_GreyColor,
        child: ListView(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                    topRight: const Radius.circular(40.0),
                  )),
              child: Image.asset(
                'images/flutter_logo.png',
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              color: Colors.white,
              child: Text(
                'Welcome to Manish\'s Flutter Challenge Implementation',
                style: TextStyle(
                  fontSize: 25,
                  color: Color(0xff757575),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                color: Colors.white,
                height: 120,
                width: double.infinity,
                child: FlatButton(
                    child: Image.asset('images/Start-Logo-FINAL-01.jpg'),
                    onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChallengesHome()),
                        ))),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              color: k_GreyColor,
              height: 310,
              width: double.infinity,
              child: ListView(
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Card(
                      elevation: 10,
                      margin: EdgeInsets.all(0),
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            FaIcon(
                              FontAwesomeIcons.file,
                              size: 25,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Flutter Reference - Articles',
                                style: k_CommonTextStyle),
                          ],
                        ),
                        onPressed: () {
                          // ToDO: Add code for on pressed
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Card(
                      elevation: 10,
                      margin: EdgeInsets.all(0),
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            FaIcon(FontAwesomeIcons.youtube),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Flutter Reference - Videos',
                                style: k_CommonTextStyle),
                          ],
                        ),
                        onPressed: () {
                          // ToDO: Add code for on pressed
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Card(
                      elevation: 10,
                      margin: EdgeInsets.all(0),
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            FaIcon(FontAwesomeIcons.envelope),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Ask Me Anything', style: k_CommonTextStyle),
                          ],
                        ),
                        onPressed: () {
                          // ToDO: Add code for on pressed
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Card(
                      elevation: 10,
                      margin: EdgeInsets.all(0),
                      child: FlatButton(
                        child: Row(
                          children: <Widget>[
                            FaIcon(FontAwesomeIcons.male),
                            SizedBox(
                              width: 10,
                            ),
                            Text('About Me', style: k_CommonTextStyle),
                          ],
                        ),
                        onPressed: () {
                          // ToDO: Add code for on pressed
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
