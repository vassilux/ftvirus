import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:ftvirus/countries/countries_bloc.dart';

import 'package:ftvirus/config/palette.dart';
import 'package:ftvirus/config/themes.dart';
import 'package:ftvirus/models/country_stats.dart';
import 'package:ftvirus/widgets/row_margin_widget.dart';
import 'country_stats_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ftvirus/models/cases_order_type.dart';

class DropDownOderType {
  final String label;
  final CasesOrderType orderType;

  DropDownOderType(this.label, this.orderType);
  
}

class CountriesPage extends StatefulWidget {
  @override
  _CountriesPageState createState() => _CountriesPageState();
}

class _CountriesPageState extends State<CountriesPage>
    with AutomaticKeepAliveClientMixin {
  TextEditingController controller = new TextEditingController();
  DropDownOderType _selectedOrder;
  List<DropDownOderType> _orderTypes = <DropDownOderType>[
    DropDownOderType('Confirmés', CasesOrderType.cases),
    DropDownOderType('Décès', CasesOrderType.deaths),
    DropDownOderType('Guéries', CasesOrderType.recovred),
  
  ];

  @override
  void didChangeDependencies() {
    SchedulerBinding.instance.addPostFrameCallback((timestamp) async {
      await Future.delayed(Duration(milliseconds: 200));
      BlocProvider.of<CountriesBloc>(context).add(FetchCountries());
    });
    super.didChangeDependencies();
  }

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    return SingleChildScrollView(
        child: Column(children: [      
      _buildDropDownOrderBox(context),
      //_buildSearchBox(context),
      BlocBuilder<CountriesBloc, CountriesState>(
          builder: (BuildContext context, CountriesState state) {
        if (state is CountriesLoaded) {
          return Container(
              height: hp(120),
              width: wp(120),
              child: _buildContrisListView(state.countriesInfos));
        }
        if (state is CountriesFiltred) {
          return Container(
              height: hp(120),
              width: wp(120),
              child: _buildContrisListView(state.countriesInfos));
        }

        if (state is CountriesLoading) {
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

        if (state is CountriesError) {
          return Text(
            'Oups Erreur!',
            style: TextStyle(color: Colors.red),
          );
        }
        return Center(
            child: FloatingActionButton(
          onPressed: () {
            BlocProvider.of<CountriesBloc>(context).add(FetchCountries());
          },
          child: Icon(Icons.refresh),
          backgroundColor: Palette.ftvColorBlue,
        ));
      })
    ]));
  }

  Widget _buildContrisListView(List<CountryStats> countriesInfos) {
    return ListView.builder(
        shrinkWrap: false,
        itemCount: countriesInfos.length,
        itemBuilder: (BuildContext context, int index) {
          return CountryStatsWidget(
            countryStats: countriesInfos[index],
            key: Key(countriesInfos[index].country),
          );
        });
  }

  Widget _buildDropDownOrderBox(BuildContext context) {
    List<DropdownMenuItem<String>> orderTypeListDropDown = [];
    for (DropDownOderType orderType in _orderTypes) {
      setState(() {
        orderTypeListDropDown.add(new DropdownMenuItem(
            value: orderType.label,
            child: Text(
              orderType.label,
              style: AppTheme.h2Style.copyWith(
                        color: Palette.ftvColorBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
            ))));
     });
    }
  

    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          LineIcons.arrow_circle_o_down,
          size: 25.0,
          color: Palette.ftvColorBlue,
          
        ),
        SizedBox(width: 50.0),
        DropdownButton(
          items:orderTypeListDropDown,
          onChanged: (selectedOrderType) {
            print('$selectedOrderType');
            setState(() {
              _selectedOrder = _orderTypes.firstWhere(
                (order) => order.label == selectedOrderType,
                orElse: () => _orderTypes.first);

                BlocProvider.of<CountriesBloc>(context).add(FetchCountries(orderType : _selectedOrder.orderType));
             
            });
          },
          value: _selectedOrder == null ? null : _selectedOrder.label,
          
          isExpanded: false,
          hint: Text(
            'Order de trie',
            style: AppTheme.h2Style.copyWith(
                        color: Palette.ftvColorBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
          ),
        )
        )],
    );
  }

  /*Widget _buildSearchBox(BuildContext context) {
    //return Padding(
    //  padding: const EdgeInsets.all(8.0),
    //  child:
    return TextField(
      onChanged: (text) {
        _processFilter(context, text);
      },
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: "Filter",
          labelStyle: TextStyle(color: Palette.ftvColorBlue, fontSize: 20.0),
          hintText: "Saisissiez le nom de pays",
          prefixIcon: Icon(Icons.search),
          isDense: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)))),
    );
    // );
  }*/

  /*_processFilter(BuildContext context, String text) async {
    if (text.isEmpty) {
      BlocProvider.of<CountriesBloc>(context)
          .add(FiltreCountries(countryFilter: ""));
      return;
    }
    if (text.length <= 2) {
      return;
    }
    BlocProvider.of<CountriesBloc>(context)
        .add(FiltreCountries(countryFilter: text));
  }*/

  @override
  bool get wantKeepAlive => true;
}
