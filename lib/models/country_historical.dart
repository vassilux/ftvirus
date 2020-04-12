
class Cases {
  Map<String, dynamic> map;

  Cases.fromJsonMap(Map<String, dynamic> map) : map = map;
}

class Deaths {
  Map<String, dynamic> map;

  Deaths.fromJsonMap(Map<String, dynamic> map) : map = map;
}

class Recovered {
  Map<String, dynamic> map;

  Recovered.fromJsonMap(Map<String, dynamic> map) : map = map;
}

class CountryHistorical {
  Cases cases;
  Deaths deaths;
  Recovered recovered;

  CountryHistorical.fromJsonMap(Map<String, dynamic> map)
      : cases = Cases.fromJsonMap(map["cases"]),
        deaths = Deaths.fromJsonMap(map["deaths"]),
        recovered = Recovered.fromJsonMap(map["recovered"]);
}