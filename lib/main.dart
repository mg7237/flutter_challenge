import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mgflutter/screens/login.dart';
import 'screens/home_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() => runApp(MyApp());

// TODO: Check for connectivity / subscribe to connectivity stream

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Duration _duration = new Duration(seconds: 2);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(child: Login()),
    );
  }
}
