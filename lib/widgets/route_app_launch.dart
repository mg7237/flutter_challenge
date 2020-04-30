import 'package:flutter/material.dart';
import 'package:mgflutter/util/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouteAppOnLaunch extends StatefulWidget {
  @override
  _RouteAppOnLaunchState createState() => _RouteAppOnLaunchState();
}

class _RouteAppOnLaunchState extends State<RouteAppOnLaunch> {
  bool show = true;
  Widget navigateTo;

  void navigationPage() async {
    var sharedPrefInstance = await SharedPreferences.getInstance();
    bool rememberMe = sharedPrefInstance.getBool(k_RememberMe) ?? false;

    print(rememberMe);
    if (rememberMe) {
      Navigator.of(context).pushReplacementNamed(HOME);
    } else {
      Navigator.of(context).pushReplacementNamed(LOGIN);
    }
    show = false;
  }

  @override
  void initState() {
    super.initState();
    navigationPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
          inAsyncCall: show,
          color: Colors.white,
          child: Center(
            child: Text(''),
          )),
    );
  }
}
