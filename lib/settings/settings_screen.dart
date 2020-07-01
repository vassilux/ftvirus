import 'package:flutter/material.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:ftvirus/config/palette.dart';
import 'package:ftvirus/config/themes.dart';
import 'package:ftvirus/repositories/settings_preferences.dart';
import 'package:ftvirus/widgets/row_margin_widget.dart';
import 'package:responsive_screen/responsive_screen.dart';
import 'package:ftvirus/models/setting_country.dart';
import 'package:ftvirus/widgets/settings_country_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
  SettingCountry _favorituCountry = SettingsPreferences().favoriteCountry;
  Country _selectedFavoriteCountry;
  Country _selectedDashboardCountry;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;
    return Container(
        height: hp(20),
        width: wp(50),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildDefaultPreferedCountry(context),
            RowMarginWidget(hp(5)),
            _buildListViewCountries(context),
            _buildAddDashboadPart(context),
          ],
        ));
  }

  Widget _buildDefaultPreferedCountry(BuildContext context) {
    if (_selectedFavoriteCountry == null) {
      _selectedFavoriteCountry = Country(
        isoCode: _favorituCountry.isoCode,
        name: _favorituCountry.name,
        asset: _favorituCountry.asset,
        currency: _favorituCountry.currency,
        currencyISO: _favorituCountry.currencyISO,
        dialingCode: _favorituCountry.dialingCode,
      );
    }

    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    return Container(
      height: hp(8),
      width: wp(100),
      child: ListTile(
        leading: Text("Pays de Préference ",
            style: AppTheme.h2Style.copyWith(
                color: Palette.darkgrey,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        title: Container(
          child: CountryPicker(
            dense: false,
            showFlag: true,
            showDialingCode: false,
            showName: true,
            showCurrency: false,
            showCurrencyISO: false,
            onChanged: (Country country) {
              setState(() {
                _selectedFavoriteCountry = country;
                SettingsPreferences().setFavoriteCountry(SettingCountry(
                    isoCode: country.isoCode,
                    name: country.name,
                    asset: country.asset));
              });
            },
            selectedCountry: _selectedFavoriteCountry,
          ),
        ),
      ),
    );
  }

  Widget _buildListViewCountries(BuildContext context) {
    final Function hp = Screen(context).hp;
    List<SettingCountry> countries =
        SettingsPreferences().getDashboardCountries();

    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Text("Dashboard ",
                style: AppTheme.h2Style.copyWith(
                    color: Palette.darkgrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            Container(
              height: hp(30),
              color: Colors.blue,
              child: ListView.builder(
                  padding: new EdgeInsets.symmetric(vertical: 8.0),
                  shrinkWrap: false,
                  itemCount: countries.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CountryStatsWidget(country: countries[index]);
                  }),
            ),
          ],
        ));
  }

  Widget _buildAddDashboadPart(BuildContext context) {
    final Function wp = Screen(context).wp;
    final Function hp = Screen(context).hp;

    return Container(
      height: hp(10),
      width: wp(100),
      color: Colors.amberAccent,
      child: ListTile(
        leading: new IconButton(
          icon: Icon(Icons.add_circle, color: Colors.blue, size: 50.0),
          onPressed: () {
            if(_selectedDashboardCountry != null) {
              SettingCountry settingCountry = SettingCountry(isoCode: _selectedDashboardCountry.isoCode, name: _selectedDashboardCountry.name,
              asset: _selectedDashboardCountry.asset);
              SettingsPreferences().addDashboardCountry(settingCountry);
              setState(() {
               _selectedDashboardCountry = null;
              });
              

          }}
        ),
        title: Container(
          child: CountryPicker(
            dense: false,
            showFlag: true,
            showDialingCode: false,
            showName: true,
            showCurrency: false,
            showCurrencyISO: false,
            onChanged: (Country country) {
              setState(() {
                _selectedDashboardCountry = country;
              });
            },
            selectedCountry: _selectedDashboardCountry,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
