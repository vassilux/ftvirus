import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ftvirus/models/country_info_historical.dart';
import 'package:ftvirus/repositories/api_repository.dart';

abstract class DashboardCountriesEvent extends Equatable {
  const DashboardCountriesEvent();
}


class FetchDashboardCountriesInfo extends DashboardCountriesEvent {
  final List<String> countriesList;
  final int days;

  FetchDashboardCountriesInfo(
    {this.countriesList = const ["fr","it","es","deu"], this.days = 15}
  );

@override
  List<Object> get props => [];
  
}


abstract class DashboardCountriesState extends Equatable {
  const DashboardCountriesState();

  @override
  List<Object> get props => [];
}

class DashboardCountriesEmpty extends DashboardCountriesState {}

class DashboardCountriesLoading extends DashboardCountriesState {}

class DashboardCountriesStateLoaded extends DashboardCountriesState {
  final CountryInfoHistoricalList countriesInfos;

  DashboardCountriesStateLoaded({@required this.countriesInfos});

  @override
  List<Object> get props => [countriesInfos];
}

class DashboardCountriesError extends DashboardCountriesState {}


class DashboardCountriesBloc extends Bloc<DashboardCountriesEvent, DashboardCountriesState> {
  final ApiRepository apiRepository; 

  final List<String> countries= ["fr","it","es","deu"];

  DashboardCountriesBloc({@required this.apiRepository}) : assert(apiRepository != null);
  @override
  DashboardCountriesState get initialState => DashboardCountriesEmpty();

  @override
  Stream<DashboardCountriesState> mapEventToState(DashboardCountriesEvent event) async* {
    if (event is FetchDashboardCountriesInfo) {
      yield* _mapFetchCountriesInfoToState(event);
    } 
  }

  Stream<DashboardCountriesState> _mapFetchCountriesInfoToState(FetchDashboardCountriesInfo event) async* {
    try {
      
      final allData = await apiRepository.getHistoricalCountries(event.countriesList, event.days);

      if(allData.countriesInfoList.length == 0) {
         yield DashboardCountriesEmpty();
      }    

      yield DashboardCountriesStateLoaded(countriesInfos: allData);

    }catch (e) {
      print(e);
      yield DashboardCountriesError();
    }
  }


  /*Stream<DashboardCountriesState> _mapRefreshDashboardToState(DashboardCountriesEvent event) async* {
    try {
      // final DashboardModel DashboardModel = await apiRepository.getAllDashboards();
      // yield DashboardLoaded(DashboardModel: DashboardModel);
    } catch (_) {
      yield state;
    }
  }*/

}
