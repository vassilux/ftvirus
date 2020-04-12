import 'package:intl/intl.dart';

class GlobalStats {
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int active;
  int tests;
  int affectedCountries;
  String updatedDate;
  String updatedTime;
  static DateFormat formatter = DateFormat("dd/MM/yyyy");
  static DateFormat timeFormatter = DateFormat().add_Hm();

  GlobalStats.fromJson(Map<String, dynamic> map)
      : cases = map["cases"] ?? 0,
        todayCases = map["todayCases"] ?? 0,
        deaths = map["deaths"] ?? 0,
        todayDeaths = map["todayDeaths"] ?? 0,
        recovered = map["recovered"] ?? 0,
        active = map["active"] ?? 0,
        tests = map["tests"] ?? 0,
        affectedCountries = map["affectedCountries"] ?? 0,
        updatedDate = toDate(map["updated"], formatter),
        updatedTime = toDate(map["updated"], timeFormatter);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['cases'] = cases;
    data['todayCases'] = todayCases;
    data['deaths'] = deaths;
    data['todayDeaths'] = todayDeaths;
    data['tests'] = tests;
    data['affectedCountries'] = affectedCountries;
    data['recovered'] = recovered;
    data['active'] = active;
    return data;
  }

  static String toDate(int date, DateFormat formatter) {
    try {
      if (date != null) {
        return formatter.format(DateTime.fromMillisecondsSinceEpoch(date));
      }
    } catch (ex) {
      return "";
    }
    return "";
  }
}