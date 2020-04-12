import 'country_historical.dart';

class CountryInfoHistorical {
  String country;
  CountryHistorical historical;

  CountryInfoHistorical.fromJsonMap(Map<String, dynamic> map)
      : country = map["country"],
        historical = CountryHistorical.fromJsonMap(map["timeline"]);
}