import 'dart:convert';
import 'package:ftvirus/models/news.dart';
import 'package:http/http.dart' as http;

class ApiNews {
  static const baseUrl = "https://newsapi.org/v2/top-headlines";
  static const key = "be754f58488c43649dcfdef49f77d150";


  ApiNews() {
    
  }

  Future<News> getCountryNews(String countryCode) async {
   // DateTime now = DateTime.now();    
    //String formattedDate = DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: 1, )));

    //final url =
       // '$baseUrl?q=covid&from=$formattedDate&sortBy=publishedAt&apiKey=$key&Language=$countryCode';
       
    final url = "$baseUrl?country=$countryCode&apiKey=be754f58488c43649dcfdef49f77d150";
    
    try {
      print("$url");
      http.Response response = await http.get(url);       
      return News.fromJson(json.decode(response.body));    

    } on Error catch (e) {      
      throw e;
    }
  }
}
