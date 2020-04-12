
import 'package:ftvirus/models/country_stats.dart';
import 'package:ftvirus/models/global_stats.dart';
import 'package:ftvirus/models/news.dart';
import 'package:ftvirus/repositories/api_client.dart';
import 'package:flutter/material.dart';
import 'package:ftvirus/models/country_info_historical.dart';
import 'package:ftvirus/models/cases_order_type.dart';

import 'api_news.dart';

class ApiRepository {
  final ApiClient apiClient;
  final ApiNews apiNews;

  ApiRepository({@required this.apiClient, @required this.apiNews}): assert(apiClient != null), assert(apiNews != null);
  Future<GlobalStats> getAllCountryData() async {
    return apiClient.getAllCountryData();
  }

  Future<List<CountryStats>> getCountriesInfos(CasesOrderType orderType) async {
    return apiClient.getCountriesInfos(orderType);
  }

  Future<News> getCountryNews(String countryCode) async {
    return apiNews.getCountryNews(countryCode);
  }

  Future<CountryInfoHistorical> getHistoricalCountry(String countryCode, int days) {
    return apiClient.getHistoricalCountry(countryCode, days);
  }
  
}