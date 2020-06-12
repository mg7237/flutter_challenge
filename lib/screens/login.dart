import 'package:flutter/material.dart';
import 'package:mgflutter/screens/home_screen.dart';
import 'package:mgflutter/util/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mgflutter/util/firebase_auth.dart';
import 'package:mgflutter/util/alert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _text = TextEditingController();
  final _pwd = TextEditingController();
  bool _validate = true;
  bool _pwdValidate = true;
  bool _rememberMe = false;
  final FireBaseOps _auth = new FireBaseOps();
  AlertDialogs alertDialog;
  String userResponse;

  void setUserPreference(bool rememberMe) async {
    var sharedPrefInstance = await SharedPreferences.getInstance();
    sharedPrefInstance.setBool(k_RememberMe, rememberMe);
    sharedPrefInstance.setString(k_UserId, _text.text);
  }

  void checkUserProfile() async {
    var sharedPrefInstance = await SharedPreferences.getInstance();
    bool userProfile = sharedPrefInstance.getBool(k_UserProfile) ?? false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("images/background_image.png"))),
            ),
            Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 2 / 3,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                child: ListView(children: <Widget>[
                  Hero(
                      tag: 'logo',
                      child: Image.asset('images/MG_Logo.png', height: 80)),
                  SizedBox(height: 10),
                  Text(
                    'Email',
                    style: k_LabelTextStyle,
                  ),
                  TextField(
                      controller: _text,
                      style: k_CommonTextStyle,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          errorText: _validate ? null : 'Invalid email id',
                          hintText: 'Enter your email id',
                          hintStyle: TextStyle(fontSize: 15))),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Password',
                    style: k_LabelTextStyle,
                  ),
                  TextField(
                      controller: _pwd,
                      style: k_CommonTextStyle,
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                          errorText: _pwdValidate
                              ? null
                              : 'Password must be more than 5 characters',
                          border: UnderlineInputBorder(),
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(fontSize: 15))),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Text('Remember Me?'),
                      Checkbox(
                        tristate: false,
                        value: _rememberMe,
                        onChanged: (newValue) {
                          _rememberMe = newValue;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    color: Theme.of(context).accentColor,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'Login / Create Profile',
                      style: TextStyle(fontSize: 20),
                    ),
                    textColor: Colors.white,
                    onPressed: () async {
                      setState(() {
                        _validate = EmailValidator.validate(_text.text);
                        _pwdValidate = _pwd.text.length > 5 ? true : false;
                      });

                      if (_validate && _pwdValidate) {
                        bool validateCreds;
                        try {
                          validateCreds = await _auth.validateUserCredentials(
                              _text.text, _pwd.text);
                        } catch (e) {
                          print(e.toString());
                        }
                        if (validateCreds) {
                          print('Success Login');
                          setUserPreference(_rememberMe);
                          Navigator.of(context)
                              .pushReplacementNamed(USER_INFORMATION);
                        } else {
                          print('Failed Login');
                          alertDialog = new AlertDialogs(
                              title: 'Authentication Failed',
                              message:
                                  'Unable to login using credentials provided. Click OK to sign-up. Cancel to retry.');
                          userResponse =
                              await alertDialog.asyncConfirmDialog(context);

                          if (userResponse == 'OK') {
                            dynamic result =
                                await _auth.createUser(_text.text, _pwd.text);

                            if (result != null) {
                              alertDialog = new AlertDialogs(
                                  title: 'Success',
                                  message: 'You have been registered with us');
                              await alertDialog.asyncAckAlert(context);

                              setUserPreference(_rememberMe);

                              Navigator.of(context).pushReplacementNamed(HOME);
                            } else {
                              alertDialog = new AlertDialogs(
                                  title: 'Failure',
                                  message: 'Registration Failed');
                              await alertDialog.asyncAckAlert(context);
                            }
                          }
                        }
                      }
                    },
                  )

                  // EmailValidator.validate(email)
                ]))
          ]),
        ),
      ),
    );
  }
}
