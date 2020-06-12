import 'package:flutter/material.dart';
import 'package:mgflutter/util/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:mgflutter/util/countries.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform, stdout;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mgflutter/widgets/gender_select_field.dart';
import 'package:mgflutter/widgets/date_time_picker.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _text = TextEditingController();
  final _country = TextEditingController();
  String emailInitials;
  bool _display = true;
  bool _value = true;
  double _experience;

  AutoCompleteTextField<Country> autoCompleteField;
  GlobalKey key = new GlobalKey<AutoCompleteTextFieldState<Country>>();
  GlobalKey _formKey = GlobalKey<FormState>();

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
    print(Platform.operatingSystem);
    if (Platform.operatingSystem == "ios") {
      _showCupertinoDialog();
      print('is a Mac');
    } else {
      print('is not a Mac');
      _showAndroidDialog();
    }
  }

  Future<void> _showCupertinoDialog() async {
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

  Future<void> _showAndroidDialog() async {
    bool checkCameraPermission = false;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Select Image From'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Camera'),
              onPressed: () async {
                checkCameraPermission = true;
                _image =
                    await ImagePicker.pickImage(source: ImageSource.camera);
                setState(() {});
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Gallery'),
              onPressed: () async {
                _image =
                    await ImagePicker.pickImage(source: ImageSource.gallery);
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    getCountryData();
    getUserEmailInitial();
    super.initState();
  }

  Future<void> getUserEmailInitial() async {
    final prefs = await SharedPreferences.getInstance();
    final String myString = prefs.getString(k_UserId) ?? '';

    if (myString.length > 2) {
      emailInitials = myString.substring(0, 2).toUpperCase();
    }
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
            print("Item");
            print(item);
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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FlatButton(
                        onPressed: () {
                          _showImagePicker();
                        },
                        child: CircleAvatar(
                          child: (_image != null)
                              ? ClipOval(
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: Image.file(
                                      _image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : Text(emailInitials ?? ""),
                          radius: 50,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24),
                          Text(
                            "Your Name",
                            style: k_LabelTextStyle,
                          ),
                          TextFormField(
                              controller: _text,
                              style: k_CommonTextStyle,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your name';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFBDBDBD))),
                                  errorText:
                                      _text.text ?? 'Please enter your name',
                                  hintText: 'Your Name',
                                  hintStyle: TextStyle(fontSize: 16))),
                          SizedBox(height: 8),
                          Text(
                            "Gender",
                            style: k_LabelTextStyle,
                          ),
                          GenderSelectField(),
                          SizedBox(height: 8),
                          Text(
                            "Date of birth",
                            style: k_LabelTextStyle,
                          ),
                          BasicDateField(),
                          SizedBox(height: 8),
                          Text(
                            "Your Country",
                            style: k_LabelTextStyle,
                          ),
                          //SizedBox(height: 16),
                          Container(
                            child: !_display
                                ? autoCompleteField
                                : TextField(
                                    decoration: InputDecoration(
                                        hintText: 'Loading ...'),
                                  ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Your Flutter Experience",
                            style: k_LabelTextStyle,
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.red[700],
                              inactiveTrackColor: Colors.red[100],
                              trackShape: RoundedRectSliderTrackShape(),
                              trackHeight: 4.0,
                              thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 12.0),
                              thumbColor: Colors.redAccent,
                              overlayColor: Colors.red.withAlpha(32),
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 28.0),
                              tickMarkShape: RoundSliderTickMarkShape(),
                              activeTickMarkColor: Colors.red[700],
                              inactiveTickMarkColor: Colors.red[100],
                              valueIndicatorShape:
                                  PaddleSliderValueIndicatorShape(),
                              valueIndicatorColor: Colors.redAccent,
                              valueIndicatorTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            child: Slider(
                              min: 0,
                              max: 5,
                              divisions: 10,
                              value: _experience ?? 0,
                              label: _experience.toString(),
                              onChanged: (value) {
                                setState(() {
                                  _experience = value;
                                });
                              },
                              onChangeEnd: (value) {
                                setState(() {
                                  _experience = value;
                                });
                              },
                            ),
                          ),

                          SizedBox(height: 8),

                          Row(
                            children: [
                              Text('Receive Communications?'),
                              Switch(
                                  value: _value,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value;
                                    });
                                  })
                            ],
                          ),
                          SizedBox(height: 16),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: double.infinity),
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
                              color: Theme.of(context).accentColor,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                'Save My Profile',
                                style: TextStyle(fontSize: 20),
                              ),
                              textColor: Colors.white,
                              onPressed: () =>
                                  Navigator.of(context) // TODO replace
                                      .pushReplacementNamed(HOME),
                            ),
                          )
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
