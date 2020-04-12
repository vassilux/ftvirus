import 'package:flutter/material.dart';
import 'package:ftvirus/config/palette.dart';
import 'package:pie_chart/pie_chart.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> dataMap;
  final Color textColor;
  final bool showLegende;
  

  PieChartWidget({this.textColor, this.dataMap, this.showLegende = true, Key key}) : super(key: key);

  final List<Color> colorList = [
    Palette.ftvColorBlue,
    Palette.ftvColorGreen,
    Palette.ftvColorRed,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: PieChart(
          legendStyle: textColor != null
              ? TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: textColor)
              : TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32.0,
          chartRadius: MediaQuery.of(context).size.width / 2,
          showChartValuesInPercentage: true,
          showChartValues: true,
          showChartValuesOutside: true,
          chartValueBackgroundColor: Colors.grey[200],
          colorList: colorList,
          showLegends: showLegende,
          legendPosition: LegendPosition.top,
          decimalPlaces: 1,
          showChartValueLabel: true,
          initialAngle: 0,
          chartValueStyle: defaultChartValueStyle.copyWith(
            color: Colors.grey[900],
          ),
          chartType: ChartType.disc,
        ),
      ),
    );
  }
}