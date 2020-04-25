import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mgflutter/screens/login.dart';
import 'package:mgflutter/util/constants.dart';
import 'screens/home_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'widgets/check_connectivity.dart';
import 'widgets/route_app_launch.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription internetConnection;
  bool showNoInternet = false;

  @override
  void initState() {
    super.initState();
    internetConnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        showNoInternet = true;
      } else {
        showNoInternet = false;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    internetConnection.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MG Flutter Challenge',
        //debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xff427BFF),
          accentColor: Color(0xffDC3545),
        ),
        home: RouteAppOnLaunch(),
        routes: <String, WidgetBuilder>{
          LOGIN: (BuildContext context) => Login(),
          HOME: (BuildContext context) => HomeScreen(),
        });
  }
}
