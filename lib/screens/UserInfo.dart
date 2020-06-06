import 'package:flutter/material.dart';
import 'package:mgflutter/util/constants.dart';
import 'package:country_icons/country_icons.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:mgflutter/util/countries.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _text = TextEditingController();
  final _country = TextEditingController();
  bool _display = true;
  AutoCompleteTextField<Country> autoCompleteField;
  GlobalKey key = new GlobalKey<AutoCompleteTextFieldState<Country>>();
  List<Country> countryList = [];
  var _image;

  Country selectedCountry;

  void getCountryData() async {
    List<Country> countryList1;
    _display = true;
    var _url =
        'https://restcountries.eu/rest/v2/all?fields=name;alpha2Code;flag';
    var response = await http.get(_url);
    try {
      if (response.statusCode == 200) {
        dynamic jsonResponse = convert.jsonDecode(response.body);
        print(jsonResponse);
        Countries countriesList = Countries.fromJson(jsonResponse);
        countryList = countriesList.provideCountryList();
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e);
    }
    setState(() => _display = false);
  }

  _showImagePicker() {
    bool checkCameraPermission = false;

    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text(
              'Select Image',
              textScaleFactor: 1.0,
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text("Select from Camera", textScaleFactor: 1.0),
                onPressed: () async {
                  checkCameraPermission = true;
                  _image =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
              CupertinoActionSheetAction(
                child: Text("Select from Gallery", textScaleFactor: 1.0),
                onPressed: () async {
                  _image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  setState(() {});
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    getCountryData();
    super.initState();
  }

  createAutoCompleteField() {
    autoCompleteField = AutoCompleteTextField<Country>(
        key: key,
        itemBuilder: (context, item) {
          return Padding(
              padding: EdgeInsets.all(5),
              child: ListTile(
                title: Text(
                  item.countryName,
                  style: TextStyle(fontSize: 16.0),
                ),
                trailing: Container(
                  child: Image.asset(
                      'icons/flags/png/' + item.countryCode + '.png',
                      package: 'country_icons'),
                  height: 16,
                  width: 16,
                ),
              ));
        },
        itemFilter: (item, query) {
          return item.countryName.toLowerCase().startsWith(query.toLowerCase());
        },
        itemSorter: (a, b) {
          return a.countryName.compareTo(b.countryName);
        },
        itemSubmitted: (item) {
          setState(() {
            selectedCountry = item;
            autoCompleteField.textField.controller.text = item.countryName;
          });
        },
        suggestions: countryList,
        style: k_CommonTextStyle,
        clearOnSubmit: false,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            errorText: _country.text ?? 'Please select your location country',
            hintText: 'Your Location'));
  }

  @override
  Widget build(BuildContext context) {
    createAutoCompleteField();
    return Material(
        child: ModalProgressHUD(
      inAsyncCall: _display,
      color: Colors.blueAccent,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              FlatButton(
                onPressed: () {
                  _showImagePicker();
                },
                child: CircleAvatar(
                  child: (_image != null)
                      ? Image.file(
                          _image,
                          fit: BoxFit.cover,
                        )
                      : Text('MG'),
                  radius: 50,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Text(
                    "Your Name",
                    style: k_LabelTextStyle,
                  ),
                  TextField(
                      controller: _text,
                      style: k_CommonTextStyle,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          errorText: _text.text ?? 'Please enter your name',
                          hintText: 'Your Name',
                          hintStyle: TextStyle(fontSize: 15))),
                  SizedBox(height: 25),
                  Text(
                    "Your Country",
                    style: k_LabelTextStyle,
                  ),
                  SizedBox(height: 25),
                  Container(
                    height: 50,
                    child: !_display
                        ? autoCompleteField
                        : TextField(
                            decoration:
                                InputDecoration(hintText: 'Loading ...'),
                          ),
                  ),
                  SizedBox(height: 20),
                  ConstrainedBox(
                    constraints: BoxConstraints(minWidth: double.infinity),
                    child: RaisedButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      color: Theme.of(context).accentColor,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        'Save My Profile',
                        style: TextStyle(fontSize: 20),
                      ),
                      textColor: Colors.white,
                      onPressed: () => Navigator.of(context) // TODO replace
                          .pushReplacementNamed(USER_INFORMATION),
                    ),
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    ));
  }
}
