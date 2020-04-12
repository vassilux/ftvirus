import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftvirus/models/country_info_historical.dart';
import 'package:ftvirus/utils/string_tools.dart';

class CountryHistoricalLineChart extends StatelessWidget {
 
  final CountryInfoHistorical searchInfoHistorical;

  const CountryHistoricalLineChart({this.searchInfoHistorical, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(           
            child : 
            Center(
                child: charts.TimeSeriesChart(
              _createSampleData(searchInfoHistorical),
              animate: true,
              defaultRenderer: charts.LineRendererConfig(
                  includePoints: true,
                  includeArea: true,
                  strokeWidthPx: 3.5,
                  radiusPx: 5,
                  areaOpacity: 0.1),
              customSeriesRenderers: [
                charts.PointRendererConfig(customRendererId: 'customPoint')
              ],
              dateTimeFactory: const charts.LocalDateTimeFactory(),
              behaviors: _buildChartBehaviors(),
              domainAxis: _buildOrdinalAxisSpec(),
              primaryMeasureAxis: _buildNumericAxisSpec(),
            ))
          );

    
  }


  List<charts.ChartBehavior> _buildChartBehaviors() {
    
    return [
      charts.SeriesLegend(
          legendDefaultMeasure: charts.LegendDefaultMeasure.lastValue,
          showMeasures: true,
          cellPadding: const EdgeInsets.all(4.0),
          horizontalFirst: false,
          entryTextStyle: charts.TextStyleSpec(fontSize: 15),
          desiredMaxColumns: 2,
          desiredMaxRows: 2),
    ];
  }

  charts.DateTimeAxisSpec _buildOrdinalAxisSpec() {
    return charts.DateTimeAxisSpec(
        renderSpec: charts.SmallTickRendererSpec(
      
      labelStyle: charts.TextStyleSpec(
          fontSize: 13, // size in Pts.
          color: charts.Color.black),
    ));
  }

  charts.NumericAxisSpec _buildNumericAxisSpec() {
    return charts.NumericAxisSpec(
      renderSpec: charts.GridlineRendererSpec(
        
        labelStyle:
            charts.TextStyleSpec(fontSize: 13, color: charts.Color.black),
      ),
    );
  }

  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData(
      CountryInfoHistorical countryInfoHistorical) {
    Map<String, int> coronaCasesMap =
        getCasesMap(countryInfoHistorical.historical.cases.map);

    Map<String, int> coronaDeathsMap = getDeathsMap(
        countryInfoHistorical.historical.deaths.map, coronaCasesMap);

    Map<String, int> coronaRecoveredMap = getCoronaRecoveredMap(
        countryInfoHistorical.historical.recovered.map, coronaCasesMap);

    List<TimeSeriesSales> coronaCasesDataTimeSeriesSales = [];
    if (coronaCasesMap.isNotEmpty) {
      coronaCasesMap.forEach((String key, int value) {
        coronaCasesDataTimeSeriesSales
            .add(TimeSeriesSales(stringToDateTime(key), value));
      });
    }

    List<TimeSeriesSales> coronaDeathsDataTimeSeriesSales = [];
    if (coronaDeathsMap.isNotEmpty) {
      coronaDeathsMap.forEach((String key, int value) {
        coronaDeathsDataTimeSeriesSales
            .add(TimeSeriesSales(stringToDateTime(key), value));
      });
    }

    List<TimeSeriesSales> coronaRecoveredDataTimeSeriesSales = [];

    if (coronaRecoveredMap.isNotEmpty) {
      coronaRecoveredMap.forEach((String key, int value) {
        coronaRecoveredDataTimeSeriesSales
            .add(TimeSeriesSales(stringToDateTime(key), value));
      });
    }

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Confirmés',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.darker,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: coronaCasesDataTimeSeriesSales,
      ),
      if (coronaDeathsDataTimeSeriesSales.isNotEmpty) ...{
        charts.Series<TimeSeriesSales, DateTime>(
            id: 'Décés',
            colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.darker,
            domainFn: (TimeSeriesSales sales, _) => sales.time,
            measureFn: (TimeSeriesSales sales, _) => sales.sales,
            data: coronaDeathsDataTimeSeriesSales)
      },
      if (coronaRecoveredDataTimeSeriesSales.isNotEmpty) ...{
        charts.Series<TimeSeriesSales, DateTime>(
          id: 'Guérisons',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault.darker,
          domainFn: (TimeSeriesSales sales, _) => sales.time,
          measureFn: (TimeSeriesSales sales, _) => sales.sales,
          data: coronaRecoveredDataTimeSeriesSales,
        )
      }
    ];
  }
}

Map<String, dynamic> getCasesMap(Map<String, dynamic> values) {
  Map<String, int> dateValues = {};
  if (values == null || values.isEmpty) {
    return dateValues;
  }
  int count = 0;
  values.forEach((String key, dynamic value) {
    if (count % 16 == 0) {
      dateValues[key] = value;
    }
    count = count + 1;
  });
  if (values.length % 14 != 0) {
    dateValues[values.keys.elementAt(values.length - 1)] =
        values.values.elementAt(values.length - 1);
  }
  return dateValues;
}

Map<String, int> getDeathsMap(
    Map<String, dynamic> values, Map<String, int> cases) {
  Map<String, int> dateValues = {};
  if (values == null || values.isEmpty) {
    return dateValues;
  }
  cases.forEach((String key, int value) {
    dateValues[key] = values[key];
  });
  return dateValues;
}

Map<String, int> getCoronaRecoveredMap(
    Map<String, dynamic> values, Map<String, int> cases) {
  Map<String, int> dateValues = {};
  if (values == null || values.isEmpty) {
    return dateValues;
  }
  cases.forEach((String key, int value) {
    dateValues[key] = values[key];
  });
  return dateValues;
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
