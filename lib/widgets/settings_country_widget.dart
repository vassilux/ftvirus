import 'package:flutter/material.dart';
import 'package:ftvirus/config/palette.dart';
import 'package:ftvirus/config/themes.dart';
import 'package:ftvirus/models/setting_country.dart';

class CountryStatsWidget extends StatelessWidget {
  final SettingCountry country;

  CountryStatsWidget({@required this.country, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          height: 50,
          child: Card(
              child: Row(children: <Widget>[
            /*Container(
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(29),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(country.asset),
                )),*/
            SizedBox(
              width: 5,
            ),
            Text(
                      country.name,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.h3Style.copyWith(
                          color: Palette.darker,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
            /*Expanded(
                child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: Center(
                    child: Text(
                      country.name,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.h2Style.copyWith(
                          color: Palette.darker,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ))*/
          ])))
    ]);
  }
}
