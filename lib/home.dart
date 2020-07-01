import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ftvirus/news/news_bloc.dart';
import 'package:ftvirus/search/search_bloc.dart';
import 'package:ftvirus/config/palette.dart';
import 'package:ftvirus/countries/countries_screen.dart';
import 'package:ftvirus/dashboard/dashboard_screen.dart';
import 'package:ftvirus/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:ftvirus/widgets/row_margin_widget.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ftvirus/dashboard/dashboard_bloc.dart';
import 'package:ftvirus/countries/countries_bloc.dart';
import 'package:ftvirus/news/news_screen.dart';
import 'package:ftvirus/settings/settings_screen.dart';
import 'package:ftvirus/dashboard/dashboard_countries_bloc.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String AD_MOB_APP_ID = 'ca-app-pub-7052516540890615~5325039440';
const String AD_MOB_TEST_DEVICE =
    'DB9DBD6F4224F26E8B654F2B23B258D0';
const String AD_MOB_AD_ID = 'ca-app-pub-7052516540890615/9699398721';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  //
  
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  //
  BannerAd _bannerAd;
  bool _adShown = false;

  BannerAd createBannerAd() {
    return new BannerAd(
      size: AdSize.banner,
      adUnitId:  AD_MOB_AD_ID, //BannerAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          _adShown = true;
          setState(() {});
        } else if (event == MobileAdEvent.failedToLoad) {
          _adShown = false;
          setState(() {});
        }
      },
    );
  }

  //Add the following code inside the State of the StatefulWidget
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>[
      'covid',
      'coronavirus',
      'covid19'
    ], //Add your own keywords  
    testDevices: <String>[
      AD_MOB_TEST_DEVICE
    ], 
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

  @override
  void initState() {   
    super.initState();
    FirebaseAdMob.instance.initialize(appId: AD_MOB_APP_ID);
    _adShown = false;
    _bannerAd = createBannerAd()
      ..load()
      ..show();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
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
                  const RowMarginWidget(25),
                  Center(
                    child: Text(
                      'Situation Mondiale COVID 19',
                      style: TextStyle(
                        fontSize: 20,
                        color: Palette.ftvColorBlue,
                      ),
                    ),
                  ),
                  const RowMarginWidget(2),
                ],
              ),
            ),
            const RowMarginWidget(10),
            //buildPageView(),
            Expanded(child: buildPageView()),
          ],
        ),
        bottomNavigationBar: Stack(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment:  MainAxisAlignment.center,
          children: [
            _buildNavbar(context),
          ],
        ),
        //persistentFooterButtons:
        //    _adShown ? _buildAdmobPlaceWidget(context) : null,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedIndex == 0) {              
              //
              BlocProvider.of<DashboardBloc>(context).add(FetchDashboard());
              BlocProvider.of<DashboardCountriesBloc>(context)
                  .add(FetchDashboardCountriesInfo());
            }

            if (selectedIndex == 1) {
              BlocProvider.of<CountriesBloc>(context)
                  .add(FetchCountries(useLastOrderType: true));
            }

            if (selectedIndex == 2) {
              BlocProvider.of<SearchBloc>(context)
                  .add(FetchSearch(userLastCountry: true));
            }

            if (selectedIndex == 3) {
              BlocProvider.of<NewsBloc>(context).add(RefreshNews());
            }
          },
          child: Icon(Icons.refresh),
          backgroundColor: Palette.ftvColorBlue,
        ));
  }

  Widget _buildNavbar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 50),//the place for admob
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
    );
  }

  List<Widget> _buildAdmobPlaceWidget(BuildContext context) {
    List<Widget> fakeBottomButtons = new List<Widget>();
    fakeBottomButtons.add(new Container(
      height: 50.0,
      color: Colors.red,
    ));
    return fakeBottomButtons;
  }
}
