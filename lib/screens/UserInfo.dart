import 'package:flutter/material.dart';
import 'package:mgflutter/util/constants.dart';
import 'package:country_icons/country_icons.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:mgflutter/util/countries.dart';

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

  Country selectedCountry;

  void getCountryData() async {
    List<Country> countryList1;
    _display = true;
    var _url =
        'https://restcountries.eu/rest/v2/all?fields=name;alpha3Code;flag';
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
            padding: EdgeInsets.all(10),
            child: ListTile(
                title: Text(
              item.countryName,
              style: TextStyle(fontSize: 10.0),
            )),
          );
        },
        itemFilter: (item, query) {
          return item.countryName.toLowerCase().startsWith(query.toLowerCase());
        },
        itemSorter: (a, b) {
          return a.countryName.compareTo(b.countryName);
        },
        itemSubmitted: (item) {
          setState(() => selectedCountry = item);
        },
        suggestions: countryList,
        style: k_CommonTextStyle,
        //textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            border: UnderlineInputBorder(),
            errorText: _country.text ?? 'Please select your location country',
            hintText: 'Your Location 123'));
  }

  @override
  Widget build(BuildContext context) {
    createAutoCompleteField();
    return Material(
      child: ModalProgressHUD(
        inAsyncCall: _display,
        color: Colors.blueAccent,
        child: Scaffold(
          body: Container(
            width: 200,
            margin: EdgeInsets.only(top: 30),
            child: ConstrainedBox(
              constraints: BoxConstraints.tightForFinite(
                  width: 200, height: double.infinity),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: () {
                      //TODO: Implement
                    },
                    child: CircleAvatar(
                      child: Text('MG'),
                      radius: 30,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Your Name"),
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
                  SizedBox(height: 20),
                  Text("Your Location"),
                  Container(
                    height: 50,
                    child: !_display
                        ? autoCompleteField
                        : TextField(
                            decoration:
                                InputDecoration(hintText: 'Loading ...'),
                          ),
                    color: Colors.red,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ConstrainedBox(
                          constraints:
                              BoxConstraints.tightFor(width: 200, height: 20),
                          child: selectedCountry != null
                              ? Text(selectedCountry.countryName)
                              : Icon(Icons.cancel)),
                      //Image.asset('images/MG_Logo.png', package: 'country_icons'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
