import 'dart:convert';
import 'package:ftvirus/models/setting_country.dart';
import 'package:ftvirus/models/settings_dashboard_countries.dart';
import 'package:shared_preferences/shared_preferences.dart';

const favorite_country = "favorite_country";
const dashboard_countries = "dashboard_countries";

const dashboard_country1 = "dashboard_country1";
const dashboard_country2 = "dashboard_country2";
const dashboard_country3 = "dashboard_country3";
const dashboard_country4 = "dashboard_country4";




//isoCode: "FR", name: "France"
class SettingsPreferences {
  static final SettingsPreferences _settingsPreferences =
      SettingsPreferences._internal();

  factory SettingsPreferences() => _settingsPreferences;

  SettingsPreferences._internal();

  SharedPreferences _sharedPreferences;

  SettingCountry favoriteCountry = SettingCountry(
      name: "France",
      asset: "assets/flags/fr_flag.png", 
      dialingCode: "33",
      isoCode: "FR",
      currency: "EUR",
      currencyISO: "EUR");

  SettingsDashboardCountries dashboardCountries = SettingsDashboardCountries();

  Future<void> initSharedPreferencesProp() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _initFavoriteCountry();
    _initDashboardCountries();
  }

  List<SettingCountry> getDashboardCountries(){
    return dashboardCountries.countries;
  }

  void _initFavoriteCountry() {
    var favoriteCountryString =
        _sharedPreferences.getString(dashboard_country1);
    if (favoriteCountryString != null) {
      favoriteCountry =
          SettingCountry.fromJson(json.decode(favoriteCountryString)); 
    }
  }

  Future<void> setFavoriteCountry(SettingCountry country) async {
    favoriteCountry.isoCode = country.isoCode;
    favoriteCountry.name = country.name;
    favoriteCountry.asset = country.asset;
    await _sharedPreferences.setString(favorite_country, json.encode(country));
  }

  void _initDashboardCountries() {
    var dashboardCountriesString =
        _sharedPreferences.getString(dashboard_countries);

    if (dashboardCountriesString != null) {
      dashboardCountries.fromString(dashboardCountriesString);
    }
  }

  Future<void> addDashboardCountry(SettingCountry country) async {
    dashboardCountries.addCountry(country);
    await _saveDashboardCountries();
  }

  Future<void> removeDashboardCountry(SettingCountry country) async {
    dashboardCountries.removeCountry(country);
    await _saveDashboardCountries();
  }

  Future<void> _saveDashboardCountries() async {
    await _sharedPreferences.setString(
        favorite_country, dashboardCountries.toString());
  }

  List<String> getisoCodes() {
    List<String> isocodes = [];   

    for (int i = 0; i < dashboardCountries.countries?.length ?? 0; i++) {
      isocodes.add(dashboardCountries.countries[i].isoCode);
    }
    return isocodes;
  }
 
}
