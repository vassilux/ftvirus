import 'package:flutter/scheduler.dart';
import 'package:ftvirus/config/palette.dart';
import 'package:ftvirus/config/themes.dart';
import 'package:ftvirus/models/country_info_historical.dart';
import 'package:ftvirus/widgets/country_historical_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftvirus/widgets/pie_chart_widget.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'search_bloc.dart';
import 'package:ftvirus/repositories/settings_preferences.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin {
  SettingCountry _favorituCountry = SettingsPreferences().favoriteCountry;
  Country _selected;

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    if (_selected == null) {
      _selected = Country(
        isoCode: _favorituCountry.isoCode,
        name: _favorituCountry.name,
        asset: _favorituCountry.asset,
        currency: _favorituCountry.currency,
        currencyISO: _favorituCountry.currencyISO,
        dialingCode: _favorituCountry.dialingCode,
      );
    }
  }

  @override
  void didChangeDependencies() {
    
    SchedulerBinding.instance.addPostFrameCallback((timestamp) async {
      await Future.delayed(Duration(milliseconds: 200));
     BlocProvider.of<SearchBloc>(context).add(FetchSearch());
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Center(
          child: Text("Choix de pays(40 dernièrs jours)", style: AppTheme.h2Style.copyWith(color: Palette.darkgrey, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
        Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CountryPicker(
              dense: false,
              showFlag: true,
              showDialingCode: false,
              showName: true,
              showCurrency: false,
              showCurrencyISO: false,
              nameTextStyle: AppTheme.h2Style.copyWith(color: Palette.darkgrey, fontWeight: FontWeight.bold, fontSize: 16),
              onChanged: (Country country) {
                setState(() {
                  _selected = country;
                  BlocProvider.of<SearchBloc>(context)
                      .add(FetchSearch(countryCode: country.isoCode));
                });
              },
              selectedCountry: _selected,
            ), 
            //Text("Vue de 40 dernièrs jours", style: AppTheme.h2Style.copyWith(color: Palette.darkgrey, fontWeight: FontWeight.bold, fontSize: 16)),
            /*Container(
              height: 25.0,
              width: 25.0,
              child: FloatingActionButton(
                
            onPressed: () {
              BlocProvider.of<SearchBloc>(context).add(FetchSearch(countryCode: _selected.isoCode));
            },
            child: Icon(Icons.refresh),
            backgroundColor: Palette.ftvColorBlue,
          ))*/
          ],
        )),
        Container(
            height: hp(50),
            width: wp(120),
            child:
                BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
              if (state is SearchLoaded) {
                return CountryHistoricalLineChart(
                    searchInfoHistorical: state.currentData);
              }
              return Text("");
            })),
        Container(
            height: hp(50),
            width: wp(50),
            child:
                BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
              if (state is SearchLoaded) {
                return PieChartWidget(
                  textColor: Colors.black,
                  dataMap: _getPieChartData(state.currentData),
                  showLegende: false,
                );
              }
              return Text("");
            })),
      ],
    ));
  }

  int calculateTotal(Map<String, dynamic> map) {
    int total = 0;
    map.forEach((k, v) {
      total += v;
    });
    return total;
  }

  Map<String, double> _getPieChartData(CountryInfoHistorical data) {
    Map<String, double> dataMap = Map();
    int totalCases = calculateTotal(data.historical.cases.map);
    int totalRecovered = calculateTotal(data.historical.recovered.map);
    int totalDeaths = calculateTotal(data.historical.deaths.map);

    dataMap.putIfAbsent("Confirmés : $totalCases", () => totalCases.toDouble());
    dataMap.putIfAbsent(
        "Guérisons : $totalRecovered", () => totalRecovered.toDouble());
    dataMap.putIfAbsent("Décés : $totalDeaths", () => totalDeaths.toDouble());

    return dataMap;
  }

  @override
  bool get wantKeepAlive => true;
}
