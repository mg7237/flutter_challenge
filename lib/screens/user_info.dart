import 'package:flutter/material.dart';
import 'package:mgflutter/util/constants.dart';
import 'package:mgflutter/widgets/country_auto_suggest.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show File, Platform;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mgflutter/widgets/gender_select_field.dart';
import 'package:mgflutter/widgets/date_time_picker.dart';
import 'package:mgflutter/util/firebase_crud.dart';
import 'package:mgflutter/util/firebase_storage.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';

/// User Information Create / Read / Update from Firestore DB
/// Most commonly used controls implemented including drop down & auto complete

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _name = TextEditingController();

  String _emailInitials;
  String _email;
  String _imageURL = "";
  int _gender;
  bool _receiveComms = true;
  double _experience;
  DateTime _dob;
  File _image;
  bool _display = true;
  String _selectedCountry;
  UserProfile _initUserProfile;
  FocusNode _focusNode = FocusNode();

  GlobalKey _formKey = GlobalKey<FormState>();
  UserProfile _userProfile;

  /// Pulling state up
  void userSelectedGender(int genderValue) {
    _gender = genderValue;
  }

  /// Pulling state up
  void selectedDate(DateTime value) {
    _dob = value;
  }

  /// Pulling state up
  void userSelectedCountry(String country) {
    _selectedCountry = country;
  }

  /// Depending on the OS, show iOS or Android style option select dialog
  /// Once user selects a new image, delete old image and create new image
  /// at Firebase Storage

  _showImagePicker() async {
    try {
      _image = null;
      print(Platform.operatingSystem);
      if (Platform.operatingSystem == "ios") {
        await _showCupertinoDialog();
      } else {
        await _showAndroidDialog();
      }
      if (_image != null) {
        FirebaseImageOps _firebaseImageOPS = FirebaseImageOps();
        if (_imageURL != "") {
          _firebaseImageOPS.deleteImage(documentURL: _imageURL);
        }
        _imageURL =
            await _firebaseImageOPS.uploadFile(user: _email, file: _image);
        setState(() {});
        _image = null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<UserProfile> getUserProfile(String email) async {
    try {
      FirebaseCrud _firebaseCrud = FirebaseCrud();
      UserProfile userProfile;
      userProfile = await _firebaseCrud.getUserProfile(email: email);
      return userProfile;
    } catch (e) {
      print(e.toString());
      return null;
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
    super.initState();
    initializeUserDate();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  Future<void> initializeUserDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String myString = prefs.getString(k_UserId) ?? '';
      _email = myString;
      if (myString.length > 2) {
        _emailInitials = myString.substring(0, 2).toUpperCase();
      }

      /// Updating controls with data retrieved from the DB
      getUserProfile(_email).then((value) {
        if (value != null) {
          setState(() {
            _initUserProfile = value;
            _name.text = _initUserProfile.name ?? "";
            _gender = _initUserProfile.gender;
            _dob = _initUserProfile.dateOfBirth;
            _selectedCountry = _initUserProfile.country ?? "";
            _experience = _initUserProfile.flutterExperience ?? 0;
            _receiveComms = _initUserProfile.receiveComms ?? true;
            _imageURL = _initUserProfile.imageURL ?? "";
            _display = false;
          });
        }
        setState(() {
          _display = false;
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          radius: 50,
                          child: (_imageURL != "" && _imageURL != null)
                              ? ClipOval(
                                  child: Container(
                                      height: 100,
                                      width: 100,
                                      child: Image(
                                          image: CachedNetworkImageProvider(
                                            _imageURL,
                                          ),
                                          fit: BoxFit.cover)))
                              : Text(_emailInitials ?? ""),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 24),
                          Text(
                            "Your Name",
                            style: k_LabelTextStyle,
                          ),
                          TextFormField(
                              controller: _name,
                              style: k_CommonTextStyle,
                              focusNode: _focusNode,
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
                                          BorderSide(color: Color(0xFD4D4D4))),
                                  hintText: 'Your Name',
                                  hintStyle: TextStyle(fontSize: 16))),
                          SizedBox(height: 16),
                          Text(
                            "Gender",
                            style: k_LabelTextStyle,
                          ),

                          (_display)
                              ? TextFormField()
                              : GenderSelectField(
                                  userSelectedValue: userSelectedGender,
                                  initValue: _gender,
                                ),
                          SizedBox(height: 16),
                          Text(
                            "Date of birth",
                            style: k_LabelTextStyle,
                          ),
                          (_display)
                              ? TextFormField()
                              : BasicDateField(
                                  initValue: _dob, selectedDate: selectedDate),
                          SizedBox(height: 16),
                          Text(
                            "Your Country",
                            style: k_LabelTextStyle,
                          ),
                          //SizedBox(height: 16),
                          (_display)
                              ? TextFormField()
                              : CountryAutoSuggest(
                                  countrySelected: userSelectedCountry,
                                  initCountryCode: _selectedCountry),
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
                                  value: _receiveComms,
                                  onChanged: (value) {
                                    setState(() {
                                      _receiveComms = value;
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
                              onPressed: () {
                                _userProfile = new UserProfile(
                                    name: _name.text,
                                    email: _email,
                                    gender: _gender,
                                    dateOfBirth: _dob,
                                    country: _selectedCountry,
                                    flutterExperience: _experience,
                                    receiveComms: _receiveComms,
                                    imageURL: _imageURL);
                                var firebaseCrud = FirebaseCrud();
                                firebaseCrud.saveUser(_userProfile);
                                Navigator.of(context)
                                    .pushReplacementNamed(HOME);
                              },
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
