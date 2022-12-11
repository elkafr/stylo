import 'package:stylo/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:stylo/custom_widgets/safe_area/page_container.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'package:stylo/locale/locale_helper.dart';
import 'package:stylo/providers/auth_provider.dart';
import 'package:stylo/shared_preferences/shared_preferences_helper.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;



class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  double _height, _width;
AuthProvider _authProvider;

  Widget _buildBodyItem() {
    return Container(

      height: _height-(_height*.07),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25)),

        image: DecorationImage(
          image: AssetImage("assets/images/bg.png"),
          fit: BoxFit.cover,
        ),

      ),

      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              if(_authProvider.currentLang != 'ar'){
                SharedPreferencesHelper.setUserLang('ar');
                helper.onLocaleChanged(new Locale('ar'));
                _authProvider.setCurrentLanguage('ar');
              }


            },
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: _width * 0.02),
                  child: Image.asset('assets/images/arabic.png'),
                ),
                Text(
                  AppLocalizations.of(context).translate('arabic'),

                  style: TextStyle(color: Colors.black, fontSize: 15),
                )
              ],
            ),
          ),
          Divider(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              if(_authProvider.currentLang != 'en'){
                SharedPreferencesHelper.setUserLang('en');
                helper.onLocaleChanged( Locale('en'));
                _authProvider.setCurrentLanguage('en');

              }


            },
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: _width * 0.02),
                  child: Image.asset('assets/images/english.png'),
                ),
                Text(
                  AppLocalizations.of(context).translate('english'),
                  style: TextStyle(color: Colors.black
                      , fontSize: 15),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     _authProvider   = Provider.of<AuthProvider>(context);
  

    _height = MediaQuery.of(context).size.height -
      
        MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    return PageContainer(
      child: Scaffold(

          appBar: AppBar(
            leading: IconButton(
              icon: Image.asset("assets/images/back.png"),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomeScreen()));
              },
            ),
            title: Text(AppLocalizations.of(context).translate('language')),
            centerTitle: true,
          ),


          body: Stack(
        children: <Widget>[
          Container(
            height: _height,
            color: mainAppColor,
            child: _buildBodyItem(),
          ),
        ],
      )),
    );
  }
}
