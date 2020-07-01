import 'dart:convert';
import 'package:ftvirus/models/setting_country.dart';


class SettingsDashboardCountries {
  List<SettingCountry> countries = [];

  void fromString(String jsonString) {
    countries = json.decode(jsonString);
  }

  String toString() {
    return json.encode(countries);
  }

  void addCountry(SettingCountry country) {
    countries.add(country);
  }

  void removeCountry(SettingCountry country) {
    countries.remove(country);
  }
}