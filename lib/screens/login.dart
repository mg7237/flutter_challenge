import 'package:flutter/material.dart';
import 'package:mgflutter/util/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mgflutter/util/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _text = TextEditingController();
  final _pwd = TextEditingController();
  bool _validate = false;
  bool _pwdValidate = false;
  final FireBaseOps _auth = new FireBaseOps();

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
                  // TODO Hero(),
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
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            errorText: _validate ? 'Invalid email id' : null,
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
                        decoration: InputDecoration(
                            errorText: !_pwdValidate
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
                          _validate = !EmailValidator.validate(_text.text);
                          _pwdValidate = _pwd.text.length > 5 ? false : true;
                        });
                        if (_validate || _pwdValidate) {
                        } else {
                          dynamic result =
                              await _auth.createUser(_text.text, _pwd.text);

                          if (result != null) {
                            AlertDialog(
                                title: Text('Success'),
                                content:
                                    Text('You have been registered with us'));
                          } else {
                            AlertDialog(
                                title: Text('Failed'),
                                content: Text('User registered successfully'));
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
