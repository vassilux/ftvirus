import 'package:flutter/material.dart';
import 'package:ftvirus/config/palette.dart';
import 'package:ftvirus/config/themes.dart';
import 'package:ftvirus/models/country_stats.dart';

class CountryStatsWidget extends StatelessWidget {
  final CountryStats countryStats;
  final bool showCountry;

  CountryStatsWidget({this.showCountry = true, this.countryStats, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
          height: 100,
          child: Card(
          child: Row(children: <Widget>[
            Container(
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
                  backgroundImage: NetworkImage(countryStats.countryInfo.flag),
                )),
            SizedBox(
              width: 5,
            ),
            Expanded(
                child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: Center(
                    child: Text(
                      countryStats.country,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.h2Style.copyWith(color: Palette.darker, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.74,
                    color: Colors.grey[300],
                    height: 1,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Center(
                              child: Text(
                            "Confirmés",
                            style: AppTheme.h2Style.copyWith(color: Palette.ftvColorBlue, fontWeight: FontWeight.bold, fontSize: 16),
                          ))),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: Center(
                              child: Text(
                            "Décès",
                            style: AppTheme.h2Style.copyWith(color: Palette.ftvColorRed, fontWeight: FontWeight.bold, fontSize: 16),
                          ))),
                      Expanded(
                        child: Center(
                            child: Text(
                          "Guéris",
                          style: AppTheme.h2Style.copyWith(color: Palette.ftvColorGreen, fontWeight: FontWeight.bold, fontSize: 16),
                        )),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: MediaQuery.of(context).size.width * 0.26,
                          child: Center(
                              child: Text(
                            '${countryStats.cases}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ))),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          child: Center(
                              child: Text(
                            '${countryStats.deaths}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ))),
                      Expanded(
                        child: Center(
                            child: Text(
                          '${countryStats.recovered}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
                      )
                    ],
                  ),
                ),
              ],
            ))
          ]))
    )]);
  }
}
