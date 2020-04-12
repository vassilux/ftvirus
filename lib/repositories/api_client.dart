
import 'package:ftvirus/models/country_stats.dart';
import 'package:ftvirus/models/global_stats.dart';
import 'package:dio/dio.dart';
import 'package:ftvirus/models/country_info_historical.dart';
import 'package:ftvirus/models/cases_order_type.dart';

class ApiClient {
  static const baseUrl = "https://corona.lmao.ninja";

  static const historicalUrl = "https://corona.lmao.ninja/v2/historical";

  Dio _dio;
  ApiClient() {
    BaseOptions options = BaseOptions(
        receiveTimeout: 100000, connectTimeout: 100000, baseUrl: baseUrl);
    _dio = Dio(options);
  }

  Future<GlobalStats> getAllCountryData() async {
    final url = '$baseUrl/all';
    try {
      final response = await _dio.get(url);
      return GlobalStats.fromJson(response.data);
    } on DioError catch (e) {
      print(e.error);
      throw e.error;
    }
  }

  Future<List<CountryStats>> getCountriesInfos(CasesOrderType order) async {
    var param = "cases";
    if(order == CasesOrderType.deaths){
      param = "deaths";
    }else if(order == CasesOrderType.recovred){
      param = "recovred";
    }
    final url = '$baseUrl/countries?sort=$param';    
    print('$url');
    print(url);
    try {
      final response = await _dio.get(url);
      return (response.data as List<dynamic>)
          .map((dynamic res) =>
              CountryStats.fromJson(res as Map<String, dynamic>))
          .toList();
    } on DioError catch (e) {
      print(e.error);
      throw e.error;
    }
  }

  Future<CountryInfoHistorical> getHistoricalCountry(String countryCode, int days) async {
      final url = '$historicalUrl/$countryCode?lastdays=$days';
      print(url);
      try {
        final response = await _dio.get(url);
        return CountryInfoHistorical.fromJsonMap(response.data);     
            
      } on DioError catch (e) {
        print(e.error);
        throw e.error;
      }
    }
  }
  
  
