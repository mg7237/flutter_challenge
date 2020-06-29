import 'package:flutter/material.dart';
import 'package:mgflutter/util/countries.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:mgflutter/util/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

/// Auto complete field for Countries retrieved from REST API providing
/// Get Country List method to get code and name of all countries.

class CountryAutoSuggest extends StatefulWidget {
  final Function countrySelected;
  final String initCountryCode;

  CountryAutoSuggest({this.countrySelected, this.initCountryCode});

  @override
  _CountryAutoSuggestState createState() => _CountryAutoSuggestState();
}

class _CountryAutoSuggestState extends State<CountryAutoSuggest> {
  final _country = TextEditingController();
  AutoCompleteTextField<Country> autoCompleteField;
  GlobalKey key = new GlobalKey<AutoCompleteTextFieldState<Country>>();
  TextEditingController _textController = TextEditingController();

  List<Country> countryList = [];
  Country selectedCountry;
  bool _display = false;

  /// Call restcountries.eu REST call to retrieve list of countries and populate
  /// countryList array which holds list of countries.
  void getCountryData() async {
    _display = false;
    var _url =
        'https://restcountries.eu/rest/v2/all?fields=name;alpha2Code;flag';
    var response = await http.get(_url);
    try {
      if (response.statusCode == 200) {
        dynamic jsonResponse = convert.jsonDecode(response.body);
        Countries countriesList = Countries.fromJson(jsonResponse);
        countryList = countriesList.provideCountryList();
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print(e.toString());
    }
    setState(() => _display = true);
    if (widget.initCountryCode != null) {
      getInitialCountry();
    }
  }

  /// The data for a user could have a country selected by user in previous session.
  /// The initCountry is the country code based on which the countries array is searched
  /// for the matching country code. If there is match then the country object
  /// value is set to the one where country code matches.
  void getInitialCountry() {
    int arrayLength = countryList.length.toInt();
    bool loop = true;
    int i = 0;
    while (loop) {
      if (i == (arrayLength - 1)) {
        _textController.text = "";
        loop = false;
      } else if (countryList[i].countryCode.toUpperCase() ==
          widget.initCountryCode.toUpperCase()) {
        selectedCountry = countryList[i];
        _textController.text = selectedCountry.countryName;
        print("_textController.text ..${_textController.text}");
        loop = false;
        setState(() {});
      }
      i++;
    }
  }

  createAutoCompleteField() {
    autoCompleteField = AutoCompleteTextField<Country>(
        key: key,
        controller: _textController,
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
            widget.countrySelected(selectedCountry.countryCode);
          });
        },
        suggestions: countryList,
        style: k_CommonTextStyle,
        clearOnSubmit: false,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            border: UnderlineInputBorder(), hintText: 'Your Location'));
  }

  @override
  void initState() {
    getCountryData();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    createAutoCompleteField();
    return Container(
      child: _display
          ? autoCompleteField
          : TextField(
              decoration: InputDecoration(hintText: 'Loading ...'),
            ),
    );
  }
}
