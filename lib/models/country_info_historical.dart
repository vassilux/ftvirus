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

  factory CountryInfoHistoricalList.fromJson(dynamic json) {

    List<CountryInfoHistorical> countriesInfoList = new List<CountryInfoHistorical>();  
    //API can retourn just MAP for one country query
    if(json is List)   {
      countriesInfoList = List<CountryInfoHistorical>.from(json.map((x) => CountryInfoHistorical.fromJsonMap(x)));
    }else {
      var country = CountryInfoHistorical.fromJsonMap(json);
      countriesInfoList.add(country);
    }


    
    countriesInfoList.forEach((country){
         print("$country");
    });
   
    return new CountryInfoHistoricalList(
      countriesInfoList: countriesInfoList
    );
  }
}