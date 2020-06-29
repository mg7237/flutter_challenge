import 'dart:core';

/// Class used to create list of countries from the parsed json,
/// containing data received from the countries API

class Country {
  String countryCode;
  String countryName;
  String countryFlag;

  Country({this.countryCode, this.countryName, this.countryFlag});

  factory Country.fromJson(Map<String, dynamic> parsedJsonCountry) {
    return new Country(
        countryCode: parsedJsonCountry['alpha2Code'].toLowerCase() as String,
        countryName: parsedJsonCountry['name'] as String,
        countryFlag: parsedJsonCountry['flag'] as String);
  }
}

class Countries {
  final List<Country> countries;

  Countries({
    this.countries,
  });

  factory Countries.fromJson(List<dynamic> parsedJson) {
    List<Country> countries = new List<Country>();

    countries = parsedJson.map((i) => Country.fromJson(i)).toList();

    return new Countries(
      countries: countries,
    );
  }

  List<Country> provideCountryList() {
    return this.countries;
  }
}
