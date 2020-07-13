import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mgflutter/screens/login.dart';
import 'package:mgflutter/util/constants.dart';
import 'screens/home_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'widgets/check_connectivity.dart';
import 'widgets/route_app_launch.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:mgflutter/screens/user_info.dart';

///  Application startup page; performs following functions
//    a) Define routes to login page & home pages
//    b) Subscribes to internet connectivity stream which is used to show connectivity error page when the device loses internet connection

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

    ///  Listening to connectivity stream. Based on Connectivity status
    ///  overlay for no internet connection is shown or hidden

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
    return OverlaySupport(
      child: MaterialApp(
          title: 'MG Flutter Challenge Portfolio',
          //debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Color(0xff427BFF),
            accentColor: Color(0xffDC3545),
          ),
          builder: (context, child) {
            return showNoInternet ? NoInternet() : child;
          },
          home: RouteAppOnLaunch(),
          routes: <String, WidgetBuilder>{
            LOGIN: (BuildContext context) => Login(),
            HOME: (BuildContext context) => HomeScreen(),
            USER_INFORMATION: (BuildContext context) => UserInfo(),
            CHANGE_PWD: (BuildContext context) =>
                UserInfo() // ToDo: Create Change Pwd and link here
          }),
    );
  }
}
