import 'package:ftvirus/models/country_info_historical.dart';
import 'package:ftvirus/repositories/api_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class FetchSearch extends SearchEvent {
  final String countryCode;
  final int days;
  final bool userLastCountry;

  @override
  FetchSearch({this.countryCode = "FR", this.days = 40, this.userLastCountry: false});
  List<Object> get props => [];
}

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final CountryInfoHistorical currentData;

  SearchLoaded({@required this.currentData});

  @override
  List<Object> get props => [currentData];
}

class SearchError extends SearchState {}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiRepository apiRepository;
  String _lastCountryCode;

  SearchBloc({@required this.apiRepository}) : assert(apiRepository != null);
  @override
  SearchState get initialState => SearchEmpty();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is FetchSearch) {
      yield* _mapFetchSearchToState(event);
    }
  }

  Stream<SearchState> _mapFetchSearchToState(FetchSearch event) async* {
    yield SearchLoading();
    try {  
      var countryCode = event.countryCode;  
      if(event.userLastCountry){
        countryCode = _lastCountryCode == null ? "FR" : _lastCountryCode;
      }else {
        _lastCountryCode = event.countryCode;
      }
      final histoData = await apiRepository.getHistoricalCountry(countryCode, event.days);
      yield SearchLoaded(currentData: histoData);

    } catch (e) {
      print(e);
      yield SearchError();
    }
  }
}
