import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:ftvirus/config/palette.dart';
import 'package:ftvirus/config/themes.dart';
import 'package:ftvirus/repositories/settings_preferences.dart';
import 'package:responsive_screen/responsive_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}
/*
asset: "assets/flags/gb_flag.png",
///    dialingCode: "44",
///    isoCode: "GB",
///    name: "United Kingdom",
///    currency: "British pound",
///    currencyISO: "GBP",
*/

class _SettingsPageState extends State<SettingsPage> with AutomaticKeepAliveClientMixin{
  SettingCountry _favorituCountry = SettingsPreferences().favoriteCountry;
  Country _selected ;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(_selected == null){
      _selected = Country(
        isoCode: _favorituCountry.isoCode, 
        name: _favorituCountry.name,
        asset: _favorituCountry.asset, 
        currency: _favorituCountry.currency, 
        currencyISO: _favorituCountry.currencyISO,
        dialingCode: _favorituCountry.dialingCode, );
    }
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    
    return Container(
      height: hp(50),
      width: wp(50),
      child: Column(children: [
        Text("Articles : Pays de Préference ", style: AppTheme.h2Style.copyWith(color: Palette.darkgrey, fontWeight: FontWeight.bold, fontSize: 16)),
        CountryPicker(
            dense: false,
            showFlag: true, 
            showDialingCode: false, 
            showName: true, 
            showCurrency: false,
            showCurrencyISO: false, 
            onChanged: (Country country) {
            setState(() {
              _selected = country;
              SettingsPreferences().saveFavoriteCountry(SettingCountry(isoCode: country.isoCode, name: country.name));
            });
          },
          selectedCountry: _selected,
            )
      ],)      
      
    );
  }

  @override
  bool get wantKeepAlive => true;
}