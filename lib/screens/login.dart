import 'package:flutter/material.dart';
import 'package:mgflutter/screens/home_screen.dart';
import 'package:mgflutter/util/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mgflutter/util/firebase_auth.dart';
import 'package:mgflutter/util/alert_dialog.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _text = TextEditingController();
  final _pwd = TextEditingController();
  bool _validate = true;
  bool _pwdValidate = true;
  final FireBaseOps _auth = new FireBaseOps();
  AlertDialogs alertDialog;
  String userResponse;

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
              height: MediaQuery.of(context).size.height / 2.5,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("images/background_image.png"))),
            ),
            Container(
                height: 450,
                margin: EdgeInsets.all(30),
                child: ListView(children: <Widget>[
                  SizedBox(height: 10),
                  Hero(
                      tag: 'logo',
                      child: Image.asset('images/MG_Logo.png', height: 50)),
                  SizedBox(height: 10),
                  Text(
                    'Email',
                    style: k_LabelTextStyle,
                  ),
                  SizedBox(
                    height: 80,
                    width: 300,
                    child: TextField(
                        controller: _text,
                        style: k_CommonTextStyle,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            errorText: _validate ? null : 'Invalid email id',
                            hintText: 'Enter your email id',
                            hintStyle: TextStyle(fontSize: 20))),
                  ),
                  Text(
                    'Password',
                    style: k_LabelTextStyle,
                  ),
                  SizedBox(
                    height: 80,
                    width: 350,
                    child: TextField(
                        controller: _pwd,
                        style: k_CommonTextStyle,
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        decoration: InputDecoration(
                            errorText: _pwdValidate
                                ? null
                                : 'Password must be more than 5 charcters',
                            border: UnderlineInputBorder(),
                            hintText: 'Enter your password',
                            hintStyle: TextStyle(fontSize: 20))),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 25),
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
                        print(_validate);
                        print(_pwdValidate);

                        if (_validate && _pwdValidate) {
                          bool validateCreds;
                          try {
                            validateCreds = await _auth.validateUserCredentials(
                                _text.text, _pwd.text);
                            print('result');
                          } catch (e) {
                            print('type');
                            print(e.runtimeType);
                            print('--');
                            print(e.toString());
                          }
                          if (validateCreds) {
                            print('Success Login');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          } else {
                            print('Failed Login');
                            alertDialog = new AlertDialogs(
                                title: 'Authentication Failed',
                                message:
                                    'Unable to login using email id / password provided. If this is the first time you are trying to log in then, click OK to signup using the preovided email id. Else Cancel to re-enter correct email and password.');
                            userResponse =
                                await alertDialog.asyncConfirmDialog(context);

                            if (userResponse == 'OK') {
                              dynamic result =
                                  await _auth.createUser(_text.text, _pwd.text);

                              if (result != null) {
                                alertDialog = new AlertDialogs(
                                    title: 'Success',
                                    message:
                                        'You have been registered with us');
                                alertDialog.asyncAckAlert(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              } else {
                                alertDialog = new AlertDialogs(
                                    title: 'Failure',
                                    message: 'Registration Failed');
                                alertDialog.asyncAckAlert(context);
                              }
                            }
                          }
                        }
                      })

                  // EmailValidator.validate(email)
                  //TODO Implement login
                ]))
          ]),
        ),
      ),
    );
  }
}
