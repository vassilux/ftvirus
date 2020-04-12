import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftvirus/news/news_bloc.dart';
import 'package:ftvirus/search/search_bloc.dart';
import 'package:ftvirus/config/palette.dart';
import 'package:ftvirus/countries/countries_screen.dart';
import 'package:ftvirus/dashboard/dashboard_screen.dart';
import 'package:ftvirus/search/search_screen.dart';
import 'package:ftvirus/utils/margin.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ftvirus/dashboard/dashboard_bloc.dart';
import 'package:ftvirus/countries/countries_bloc.dart';
import 'package:ftvirus/news/news_screen.dart';
import 'package:ftvirus/settings/settings_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        DashboardScreen(),
        CountriesPage(),
        SearchScreen(),
        NewsPage(),
        SettingsPage(),
      ],
    );
  }

  void pageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      selectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 200), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: <Widget>[
                const YMargin(25),
                Center(
                  child: Text(
                    'Situation Mondiale COVID 19',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black38,
                    ),
                  ),
                ),
                const YMargin(2),
              
              ],
            ),
          ),
          const YMargin(10),
          Expanded(child: buildPageView()),
          

        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.9))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10).add(EdgeInsets.only(top: 5)),
            child: GNav(
                gap: 10,
                activeColor: Colors.white,                
                color: Colors.blue,
                iconSize: 26,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                duration: Duration(milliseconds: 800),
                tabBackgroundColor: Colors.grey[200],
                tabs: [
                  GButton(
                    icon: LineIcons.dashboard,
                    text: 'Dashboard',
                    backgroundColor: Palette.ftvColorBlue,                    
                  ),                   
                  GButton(
                    icon: LineIcons.stack_exchange,
                    text: 'Pays',
                    backgroundColor: Palette.ftvColorBlue,
                  ),
                  GButton(
                    icon: LineIcons.search,
                    text: 'Recherche',
                    backgroundColor: Palette.ftvColorBlue,
                  ),
                  GButton(
                    icon: LineIcons.newspaper_o,
                    text: 'Articles',
                    backgroundColor: Palette.ftvColorBlue,
                  ),
                  GButton(
                    icon: LineIcons.cog,
                    text: 'Paramètres',
                    backgroundColor: Palette.ftvColorBlue,
                  ),
                ],
                selectedIndex: selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    pageController.jumpToPage(index);
                  });
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
            onPressed: () {
              if(selectedIndex == 0 ) {
                BlocProvider.of<DashboardBloc>(context).add(FetchDashboard());
              }

              if(selectedIndex == 1) {
                BlocProvider.of<CountriesBloc>(context).add(FetchCountries(useLastOrderType: true));
              }

              if(selectedIndex == 2) {
                 BlocProvider.of<SearchBloc>(context).add(FetchSearch(userLastCountry: true));
              }

              if(selectedIndex == 3) {
                 BlocProvider.of<NewsBloc>(context).add(RefreshNews());
              }
            },
            child: Icon(Icons.refresh),
            backgroundColor: Palette.ftvColorBlue,
          ));
    
  }
}
