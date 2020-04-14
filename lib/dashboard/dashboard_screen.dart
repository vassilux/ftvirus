import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:ftvirus/dashboard/dashboard_bloc.dart';
import 'package:ftvirus/dashboard/dashboard_countries_bloc.dart';

import 'package:ftvirus/config/themes.dart';
import 'package:ftvirus/config/palette.dart';
import 'package:ftvirus/dashboard/slider_days_widget_screen.dart';
import 'package:ftvirus/widgets/column_margin_widget.dart';

import 'package:ftvirus/widgets/pie_chart_widget.dart';
import 'package:ftvirus/widgets/row_margin_widget.dart';
import 'package:ftvirus/widgets/state_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:responsive_screen/responsive_screen.dart';

import 'countries_historical_line_chart.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin {
  final formatter = new NumberFormat("#,###", "eu");

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //
    SchedulerBinding.instance.addPostFrameCallback((timestamp) async {
      await Future.delayed(Duration(milliseconds: 200));
      BlocProvider.of<DashboardBloc>(context).add(FetchDashboard());      
      BlocProvider.of<DashboardCountriesBloc>(context)
          .add(FetchDashboardCountriesInfo());
    });

    super.didChangeDependencies();
  }

  Map<String, double> _getTotalPieChartData(DashboardLoaded state) {
    Map<String, double> dataMap = Map();
    dataMap.putIfAbsent(
        "Malades : ${formatter.format(state.currentData.active)}",
        () => state.currentData.cases.toDouble());
    dataMap.putIfAbsent(
        "Guérisons : ${formatter.format(state.currentData.recovered)}",
        () => state.currentData.recovered.toDouble());
    dataMap.putIfAbsent("Décés : ${formatter.format(state.currentData.deaths)}",
        () => state.currentData.deaths.toDouble());

    return dataMap;
  }

  Widget _buildGlobalPart(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
        builder: (BuildContext context, DashboardState state) {
      final Function wp = Screen(context).wp;
      final Function hp = Screen(context).hp;
      if (state is DashboardLoading) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RowMarginWidget(hp(29)),
            Center(
                child: SpinKitSquareCircle(
              color: Palette.ftvColorBlue,
              size: 50.0,
            )),
          ],
        );
      }

      if (state is DashboardLoaded) {
        final currentData = state.currentData;
        return Column(
          children: <Widget>[
            Center(
              child: Text(
                "Situation du  " + currentData.updatedDate,
                style: AppTheme.h2Style.copyWith(
                  color: Palette.darkgrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Center(
              child: PieChartWidget(
                textColor: Colors.black,
                dataMap: _getTotalPieChartData(state),
              ),
            ),
            Center(
              child: Text(
                "Aujourd'hui  " +
                    currentData.updatedDate +
                    ' à ' +
                    currentData.updatedTime,
                style: AppTheme.h2Style.copyWith(
                  color: Palette.darkgrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(
                width: wp(50),
                child: StateSituationCard(
                  cardTitle: 'Nouveau cas',
                  caseTitle: "Aujourd'hui",
                  stateNumber: currentData.todayCases,
                ),
              ),
              Container(
                  width: wp(45),
                  child: StateSituationCard(
                    cardTitle: 'Décés',
                    caseTitle: "Aujourd'hui",
                    stateNumber: currentData.todayDeaths,
                    cardColor: Palette.ftvColorRed,
                  )),
            ]),
            SizedBox(height: hp(3)),
          ],
        );
      }
      if (state is DashboardError) {
        return Text(
          'Oups Quelque chose a mal tourné!!',
          style: TextStyle(color: Colors.red),
        );
      }
      return Center(
          child: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<DashboardBloc>(context).add(FetchDashboard());
        },
        child: Icon(Icons.refresh),
        backgroundColor: Colors.green,
      ));
    });
  }

  Widget _buildCountriesPart(BuildContext context) {
    return BlocBuilder<DashboardCountriesBloc, DashboardCountriesState>(
        builder: (BuildContext context, DashboardCountriesState state) {
      final Function wp = Screen(context).wp;
      final Function hp = Screen(context).hp;
      if (state is DashboardCountriesStateLoaded) {
        final currentData = state.countriesInfos;
        try {
          return Container(
            height: hp(50),
            width: wp(120),
            child: CountriesHistoricalLineChart(
              currentData,
            ),
          );
        } catch (e) {
          print(e);
        }
      }

      if (state is DashboardCountriesError) {
        return Center(child: Text("Countries Place holder"));
      }

      return Text("Countries Place holder");
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
        padding: EdgeInsets.only(top: 20, bottom: 50),
        child: Column(
          children: [_buildGlobalPart(context), 
           SliderDaysWidgetScreen(),
          _buildCountriesPart(context),
          Center(child: Text("Evolution de cas confirmès ", style: AppTheme.h2Style.copyWith(color: Palette.ftvColorBlue, fontWeight: FontWeight.bold, fontSize: 16)),)
          
          ],
          
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
