import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


const favorite_country = "favorite_country";

class SettingCountry {
  String asset;
  String isoCode;
  String name;
  String dialingCode;
  String currency;
  String currencyISO;

  SettingCountry({@required this.isoCode, @required this.name});

  SettingCountry.fromJson(Map<String, dynamic> json)
      : asset = json["asset"],
        isoCode = json['isoCode'],
        name = json['name'],
        dialingCode = json["dialingCode"],
        currency = json["currency"],
        currencyISO = json["currencyISO"];
       

  Map<String, dynamic> toJson() => {
        'asset': asset,
        'isoCode': isoCode,
        'name': name,
        'dialingCode': dialingCode,
        'currency' : currency,
        'currencyISO' : currencyISO
      };
}

//isoCode: "FR", name: "France"
class SettingsPreferences {
  static SettingCountry defaultFavoritCountry =
      SettingCountry(isoCode: "FR", name: "France");

  static final SettingsPreferences _settingsPreferences =
      SettingsPreferences._internal();

  factory SettingsPreferences() => _settingsPreferences;

  SettingsPreferences._internal();

  SharedPreferences _sharedPreferences;

  SettingCountry favoriteCountry;

  Future<void> initSharedPreferencesProp() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _initFavoriteCountry();
  }

  void _initFavoriteCountry() {
    var favoriteCountryString = _sharedPreferences.getString(favorite_country);
    if (favoriteCountryString != null) {
      favoriteCountry =
          SettingCountry.fromJson(json.decode(favoriteCountryString));
    } else
      favoriteCountry = defaultFavoritCountry;
      favoriteCountry.asset = "assets/flags/fr_flag.png";
      favoriteCountry.dialingCode="33";
      favoriteCountry.isoCode="FR";
       favoriteCountry.currency="EUR";
       favoriteCountry.currencyISO="EUR";

    var country = favoriteCountry.toJson();
    _sharedPreferences.setString(favorite_country, json.encode(country));
  }

  Future<void> saveFavoriteCountry(SettingCountry country) async {
    print("$country");
    favoriteCountry.isoCode = country.isoCode;
    favoriteCountry.name = country.name;
    await _sharedPreferences.setString(favorite_country, json.encode(country));
  }
}
