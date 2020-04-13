import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:ftvirus/dashboard/dashboard_bloc.dart';
import 'package:ftvirus/config/themes.dart';
import 'package:ftvirus/config/palette.dart';
import 'package:ftvirus/widgets/pie_chart_widget.dart';
import 'package:ftvirus/widgets/row_margin_widget.dart';
import 'package:ftvirus/widgets/state_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:responsive_screen/responsive_screen.dart';

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

  Map<String, double> _getTodayPieChartData(DashboardLoaded state) {
    Map<String, double> dataMap = Map();
    dataMap.putIfAbsent(
        "Confirmés : ${formatter.format(state.currentData.todayCases)}",
        () => state.currentData.cases.toDouble());
    dataMap.putIfAbsent(
        "Malades : ${formatter.format(state.currentData.active)}",
        () => state.currentData.recovered.toDouble());
    dataMap.putIfAbsent(
        "Décés : ${formatter.format(state.currentData.todayDeaths)}",
        () => state.currentData.deaths.toDouble());

    return dataMap;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    return SingleChildScrollView(
        padding: EdgeInsets.only(top: 20),
        child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (BuildContext context, DashboardState state) {
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
                /*Container(
                      width: wp(90),
                      height: hp(40),
                      child: AreaAndLineChart.withSampleData(),
                    ),*/
                Center(
                  child: Text(
                    "Aujourd'hui  " + currentData.updatedDate,
                    style: AppTheme.h2Style.copyWith(
                      color: Palette.darkgrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
              'Something went wrong!',
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
        }));
  }

  @override
  bool get wantKeepAlive => true;
}
