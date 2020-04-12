import 'package:ftvirus/models/country_stats.dart';
import 'package:ftvirus/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftvirus/models/cases_order_type.dart';


abstract class CountriesEvent extends Equatable {
  const CountriesEvent();
}

class FetchCountries extends CountriesEvent {
  final CasesOrderType orderType;
  final useLastOrderType;

  FetchCountries({this.orderType = CasesOrderType.cases, this.useLastOrderType = false});
  @override
  List<Object> get props => [];
}

class RefreshCountries extends CountriesEvent {
  @override
  List<Object> get props => [];
}

class FiltreCountries extends CountriesEvent {
  final String countryFilter;

  FiltreCountries({@required this.countryFilter});

  @override
  List<Object> get props => [];
}

abstract class CountriesState extends Equatable {
  const CountriesState();

  @override
  List<Object> get props => [];
}

class CountriesEmpty extends CountriesState {}

class CountriesLoading extends CountriesState {}

class CountriesLoaded extends CountriesState {
  final List<CountryStats> countriesInfos;

  CountriesLoaded({@required this.countriesInfos});

  @override
  List<Object> get props => [countriesInfos];
}

class CountriesFiltred extends CountriesState {
  final List<CountryStats> countriesInfos;

  CountriesFiltred({@required this.countriesInfos});

  @override
  List<Object> get props => [countriesInfos];
}

class CountriesError extends CountriesState {}

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  final ApiRepository apiRepository;
  List<CountryStats> loadedCountries = new List<CountryStats>();
  CasesOrderType _lastOrderType;

  CountriesBloc({@required this.apiRepository}) : assert(apiRepository != null);
  @override
  CountriesState get initialState => CountriesEmpty();

  @override
  Stream<CountriesState> mapEventToState(CountriesEvent event) async* {
    if (event is FetchCountries) {
      yield* _mapFetchCountriesToState(event);
    } else if (event is RefreshCountries) {
      yield* _mapRefreshCountriesToState(event);
    } else if (event is FiltreCountries) {
      yield* _mapFilterCountriesToState(event);
    }
  }

  Stream<CountriesState> _mapFetchCountriesToState(
      FetchCountries event) async* {
    yield CountriesLoading();
    try {
      var order = CasesOrderType.cases;
      if(event.useLastOrderType) {
        order = _lastOrderType == null ? CasesOrderType.cases : _lastOrderType;
      }else {
         _lastOrderType = event.orderType;
         order = _lastOrderType;
      }
     
      final countriesList = await apiRepository.getCountriesInfos(order);
      loadedCountries.clear();
      loadedCountries.addAll(countriesList);

      yield CountriesLoaded(countriesInfos: countriesList);
    } catch (_) {
      yield CountriesError();
    }
  }

  Stream<CountriesState> _mapRefreshCountriesToState(
      RefreshCountries event) async* {
    try {
      // final CountriesModel CountriesModel = await apiRepository.getAllCountriess();
      // yield CountriesLoaded(CountriesModel: CountriesModel);
    } catch (_) {
      yield state;
    }
  }

  Stream<CountriesState> _mapFilterCountriesToState(
      FiltreCountries event) async* {
    try {
      List<CountryStats> filtredCountries = new List<CountryStats>();
      loadedCountries.forEach((countryStats) {
        if (countryStats.country.toUpperCase().contains(event.countryFilter.toUpperCase()))
          filtredCountries.add(countryStats);
      });
      yield CountriesFiltred(countriesInfos: filtredCountries);
    } catch (_) {
      yield state;
    }
  }
}
