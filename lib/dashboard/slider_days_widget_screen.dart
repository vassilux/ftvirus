import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftvirus/config/palette.dart';
import 'package:ftvirus/config/themes.dart';
import 'package:ftvirus/dashboard/dashboard_countries_bloc.dart';

class SliderDaysWidgetScreen extends StatefulWidget {
  @override
  SliderDaysWidgetScreenState createState() {
    return SliderDaysWidgetScreenState();
  }
}

class SliderDaysWidgetScreenState extends State<SliderDaysWidgetScreen> {
  int _daysValue;

  SliderDaysWidgetScreenState();

  @override
  void initState() {
    _daysValue = 15;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text("Dernièrs ${_daysValue.toInt()} jours",
              style: AppTheme.h2Style.copyWith(
                  color: Palette.ftvColorBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ),
        Slider(
          value: _daysValue.toDouble(),
          min: 7,
          max: 60,
          divisions: 10,
          label: '${_daysValue.toInt()}',
          onChangeStart: (double value) {
            print('Start value is ' + value.toString());
          },
          onChangeEnd: (double value) {
            print('Finish value is ' + value.toString());
            BlocProvider.of<DashboardCountriesBloc>(context)
                  .add(FetchDashboardCountriesInfo(days: _daysValue));
          },
          onChanged: (double newValue) {
            setState(() {
              _daysValue = newValue.round();
              print('onChanged value is ' + newValue.toString());
              /**/
            });
          },
          activeColor: Colors.blue,
          inactiveColor: Colors.black45,
        )
      ],
    );
  }
}
