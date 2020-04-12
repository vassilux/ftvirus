import 'dart:convert';
import 'package:ftvirus/models/news.dart';
import 'package:ftvirus/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftvirus/repositories/settings_preferences.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
}

class FetchNews extends NewsEvent {
  @override
  List<Object> get props => [];
}

class RefreshNews extends NewsEvent {
  @override
  List<Object> get props => [];
}

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsEmpty extends NewsState {}

class NewsLoading extends NewsState {}
class NewsLoaded extends NewsState {
  final News news;

  NewsLoaded({@required this.news});

  @override
  List<Object> get props => [news];
}

class NewsError extends NewsState {}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final ApiRepository apiRepository;

  NewsBloc({@required this.apiRepository}) : assert(apiRepository != null);
  @override
  NewsState get initialState => NewsEmpty();

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {    
    if (event is FetchNews) {
      yield* _mapFetchNewsToState(event);
    } else if (event is RefreshNews) {
      yield* _mapRefreshNewsToState(event);
    }
  }

  Stream<NewsState> _mapFetchNewsToState(FetchNews event) async* {
    yield NewsLoading();
    try {     
      var countryCode = SettingsPreferences().favoriteCountry.isoCode;      
      final news = await apiRepository.getCountryNews(countryCode);
      
      //
      yield NewsLoaded(news: news);
    } catch (_) {
      yield NewsError();
    }
  }

  Stream<NewsState> _mapRefreshNewsToState(RefreshNews event) async* {
    yield NewsLoading();
    try {     
      var countryCode = SettingsPreferences().favoriteCountry.isoCode;      
      final news = await apiRepository.getCountryNews(countryCode);      
      //
      yield NewsLoaded(news: news);
    } catch (_) {
      yield NewsError();
    }
  }
}