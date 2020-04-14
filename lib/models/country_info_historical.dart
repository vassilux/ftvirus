import 'country_historical.dart';

class CountryInfoHistorical {
  String country;
  CountryHistorical historical;

  CountryInfoHistorical.fromJsonMap(Map<String, dynamic> map)
      : country = map["country"],
        historical = CountryHistorical.fromJsonMap(map["timeline"]);
}

class CountryInfoHistoricalList {
  final List<CountryInfoHistorical> countriesInfoList;

  CountryInfoHistoricalList({
    this.countriesInfoList,
});

  factory CountryInfoHistoricalList.fromJson(List<dynamic> json) {

    List<CountryInfoHistorical> countriesInfoList = new List<CountryInfoHistorical>();


    countriesInfoList = List<CountryInfoHistorical>.from(json.map((x) => CountryInfoHistorical.fromJsonMap(x)));

    countriesInfoList.forEach((country){
         print("$country");
    });
   
    return new CountryInfoHistoricalList(
      countriesInfoList: countriesInfoList
    );
  }
}