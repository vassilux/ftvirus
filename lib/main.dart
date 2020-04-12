import 'package:flutter/foundation.dart';
import 'package:ftvirus/repositories/api_news.dart';
import 'package:ftvirus/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftvirus/repositories/settings_preferences.dart';

import 'dashboard/dashboard_bloc.dart';

import 'news/news_bloc.dart';
import 'countries/countries_bloc.dart';
import 'search/search_bloc.dart';
import 'home.dart';
import 'simple_bloc_delegate.dart';


void main() async {  

  WidgetsFlutterBinding.ensureInitialized();    
  await init();
  
  final ApiRepository apiRepository = ApiRepository(apiClient: ApiClient(), apiNews: new ApiNews());
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<DashboardBloc>(
      create: (context) => DashboardBloc(apiRepository: apiRepository),
    ),
    BlocProvider<NewsBloc>(
      create: (context) => NewsBloc(apiRepository: apiRepository),
    ),
    BlocProvider<CountriesBloc>(
      create: (context) => CountriesBloc(apiRepository: apiRepository),
    ),
    BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(apiRepository: apiRepository),
    ),
  ], child: MyApp(apiRepository: apiRepository,)));
}

Future<void> init() async {
  await SettingsPreferences().initSharedPreferencesProp();
}

class MyApp extends StatelessWidget {
  final ApiRepository apiRepository;

  const MyApp({Key key, @required this.apiRepository}) : assert(apiRepository != null), super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (BuildContext context, DashboardState state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: BlocProvider(
            create: (context) => DashboardBloc(apiRepository: apiRepository),
            child: Home(),
          ),
        );
      },
    );
  }
}
