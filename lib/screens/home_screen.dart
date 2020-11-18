import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:mgflutter/screens/reference_material.dart';
import 'package:mgflutter/util/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mgflutter/widgets/privacy_policy.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mgflutter/widgets/drawer_profile.dart';
import 'challenges_start.dart';
import 'dart:io' as io;

class HomeScreen extends StatefulWidget {
  bool loggedIn;
  HomeScreen({this.loggedIn});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isAvailable = false;

  Future<void> sendMail() async {
    print("send");
    final Email email = Email(
      body: "",
      subject: "Flutter Challenges - Query",
      recipients: ["mg7237@gmail.com"],
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
      print("success email");
    } catch (error) {
      platformResponse = error.toString();
      print("error email");
      print(platformResponse);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    exists();
  }

  void exists() async {
    _isAvailable = await io.File(
            "/data/user/0/com.manishgupta.mgflutter/app_flutter/file_example.pdf")
        .exists();
    io.File("").create();
    setState(() {
      print("Async $_isAvailable");
    });
  }

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
              child: DrawerProfile(),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'View / Update Profile',
                      style: k_CommonTextStyle,
                    ),
                    Icon(
                      Icons.person,
                      size: 20,
                    ),
                  ],
                ),
                onTap: () {
                  if (widget.loggedIn) {
                    Navigator.of(context)
                        .pushReplacementNamed(USER_INFORMATION);
                  } else {
                    Navigator.of(context).pushReplacementNamed(LOGIN);
                  }
                }),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'APP Source Code',
                    style: k_CommonTextStyle,
                  ),
                  Icon(
                    Icons.code,
                    size: 20,
                  ),
                ],
              ),
              onTap: () async {
                const url =
                    'https://github.com/mg7237/flutter_knowledge_portfolio_1';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  print('Could not launch $url');
                }
              },
            ),
            ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Privacy Policy',
                      style: k_CommonTextStyle,
                    ),
                    Icon(
                      Icons.open_in_new,
                      size: 20,
                    ),
                  ],
                ),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicy()))),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: <Widget>[
            Card(
              elevation: 10,
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      height: 75,
                      child: Image.asset(
                        'images/MG_Logo.png',
                      ),
                    ),
                    SizedBox(
                      width: 140,
                      child: Image.asset(
                        'images/flutter_logo.png',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 10,
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    color: Colors.white,
                    child: Text(
                      'Welcome to Manish\'s Flutter Challenge Implementation',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff757575),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      color: Colors.white,
                      height: 100,
                      width: double.infinity,
                      child: InkWell(
                          child: Image.asset('images/Start-Logo-FINAL-01.jpg'),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChallengesStart())))),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              height: 500,
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
                            Text('Flutter Reference Material',
                                style: k_CommonTextStyle),
                            Expanded(
                                child: Container(
                              child: Icon(Icons.keyboard_arrow_right),
                              alignment: Alignment.centerRight,
                            )),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContentView()));
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
                            Expanded(
                                child: Container(
                              child: Icon(Icons.keyboard_arrow_right),
                              alignment: Alignment.centerRight,
                            )),
                          ],
                        ),
                        onPressed: () => sendMail(),
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
                            Expanded(
                                child: Container(
                              child: Icon(Icons.keyboard_arrow_right),
                              alignment: Alignment.centerRight,
                            )),
                          ],
                        ),
                        onPressed: () async {
                          const url = 'https://mg7237.github.io/manish/';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            print('Could not - launch $url');
                          }
                        },
                      ),
                    ),
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
