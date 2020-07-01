import 'package:flutter/widgets.dart';

class SettingCountry {
  String asset;
  String isoCode;
  String name;
  String dialingCode;
  String currency;
  String currencyISO;

  SettingCountry(
      {@required this.isoCode,
      @required this.name,
      this.asset,
      this.dialingCode,
      this.currency,
      this.currencyISO});

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
        'currency': currency,
        'currencyISO': currencyISO
      };
}
