import 'dart:async';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ftvirus/repositories/api_news.dart';
import 'package:ftvirus/repositories/repositories.dart';
import 'package:ftvirus/repositories/settings_preferences.dart';
import 'package:ftvirus/dashboard/dashboard_countries_bloc.dart';
import 'dashboard/dashboard_bloc.dart';
import 'news/news_bloc.dart';
import 'countries/countries_bloc.dart';
import 'search/search_bloc.dart';
import 'home.dart';
import 'simple_bloc_delegate.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  final ApiRepository apiRepository =
      ApiRepository(apiClient: ApiClient(), apiNews: new ApiNews());
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MultiBlocProvider(
      providers: [
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
        BlocProvider<DashboardCountriesBloc>(
          create: (context) =>
              DashboardCountriesBloc(apiRepository: apiRepository),
        ),
      ],
      child: MyApp(
        apiRepository: apiRepository,
      )));
}

Future<void> init() async {
  await SettingsPreferences().initSharedPreferencesProp();
}

class MyApp extends StatefulWidget {
  final ApiRepository apiRepository;

  const MyApp({Key key, this.apiRepository}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState(apiRepository: apiRepository);
}

class _MyAppState extends State<MyApp> {
  final ApiRepository apiRepository;

  _MyAppState({@required this.apiRepository});

  @override
  void initState() {    
    super.initState();
  }

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
