import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mgflutter/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mgflutter/util/constants.dart';
import 'package:mgflutter/util/firebase_auth.dart';
import 'package:mgflutter/util/alert_dialog.dart';
import 'package:mgflutter/widgets/ensure_visible_when_focused.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Login page uses FireStore Authentication (user/password)
/// to create & authenticate users

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
  AlertDialogs asyncAckAlert;
  String userResponse;
  FocusNode _focusNodeUserId = FocusNode();
  FocusNode _focusNodePassword = FocusNode();
  FocusNode _focusLoginButton = FocusNode();

  /// Set remember me and user id to SharedPreference
  Future<void> setUserPreference() async {
    try {
      var sharedPrefInstance = await SharedPreferences.getInstance();
      sharedPrefInstance.setBool(k_RememberMe, _rememberMe);
      sharedPrefInstance.setString(k_UserId, _text.text);
    } catch (e) {
      print(e.toString());
    }
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
                  EnsureVisibleWhenFocused(
                    focusNode: _focusNodeUserId,
                    child: TextField(
                        controller: _text,
                        focusNode: _focusNodeUserId,
                        style: k_CommonTextStyle,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            errorText: _validate ? null : 'Invalid email id',
                            hintText: 'Enter your email id',
                            hintStyle: TextStyle(fontSize: 15))),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Password',
                    style: k_LabelTextStyle,
                  ),
                  EnsureVisibleWhenFocused(
                    focusNode: _focusNodePassword,
                    child: TextField(
                        controller: _pwd,
                        focusNode: _focusNodePassword,
                        style: k_CommonTextStyle,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          _focusNodePassword.unfocus();
                          FocusScope.of(context)
                              .requestFocus(_focusLoginButton);
                        },
                        decoration: InputDecoration(
                            errorText: _pwdValidate
                                ? null
                                : 'Password must be more than 5 characters',
                            border: UnderlineInputBorder(),
                            hintText: 'Enter your password',
                            hintStyle: TextStyle(fontSize: 15))),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('Remember Me?', style: TextStyle(fontSize: 18)),
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
                      InkWell(
                        child: Text(
                          "Skip   ",
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 18),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      loggedIn: false,
                                    ))),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  RaisedButton(
                    focusNode: _focusLoginButton,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    color: Theme.of(context).accentColor,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'Login / Sign Up',
                      style: TextStyle(fontSize: 20),
                    ),
                    textColor: Colors.white,
                    onPressed: () async {
                      setState(() {
                        _validate = EmailValidator.validate(_text.text);
                        _pwdValidate = _pwd.text.length > 5 ? true : false;
                      });

                      if (_validate && _pwdValidate) {
                        bool validateCreds = false;
                        try {
                          validateCreds = await _auth.validateUserCredentials(
                              _text.text, _pwd.text);
                        } catch (e) {
                          print(e.toString());
                        }
                        if (validateCreds) {
                          await setUserPreference();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                        loggedIn: true,
                                      )));
                        } else {
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

                              await setUserPreference();

                              ///                           Navigate to User Info only in case of user
                              ///                           registration else redirect to Home Page
                              Navigator.of(context)
                                  .pushReplacementNamed(USER_INFORMATION);
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
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: InkWell(
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                        onTap: () async {
                          _validate = EmailValidator.validate(_text.text);
                          if (_validate) {
                            try {
                              final FirebaseAuth _auth = FirebaseAuth.instance;
                              _auth
                                  .sendPasswordResetEmail(email: _text.text)
                                  .then((value) async {
                                alertDialog = new AlertDialogs(
                                    title: 'Success',
                                    message:
                                        'Password reset email has been sent to your mail id. Please check and change password');
                                await alertDialog.asyncAckAlert(context);
                              }).catchError((onError) async {
                                alertDialog = new AlertDialogs(
                                    title: 'Failure',
                                    message:
                                        'Password change request failed. Please check the email entered and try again.');
                                await alertDialog.asyncAckAlert(context);
                              });
                            } catch (e) {
                              alertDialog = new AlertDialogs(
                                  title: 'Failure',
                                  message:
                                      'Password change request failed. Please check the email entered and try again.');
                              await alertDialog.asyncAckAlert(context);
                            }
//        .catchError(onError) {
//                            print("err");
//    });

                          }
                        }),
                  ),
                ]))
          ]),
        ),
      ),
    );
  }
}
