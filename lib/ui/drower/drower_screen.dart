
import 'package:stylo/ui/auth/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stylo/ui/my_ads/my_ads1_screen.dart';
import 'package:stylo/ui/my_ads/my_ads2_screen.dart';
import 'package:stylo/ui/notification/notification_screen.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:stylo/custom_widgets/dialogs/log_out_dialog.dart';
import 'package:stylo/custom_widgets/safe_area/page_container.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'package:stylo/providers/auth_provider.dart';
import 'package:stylo/providers/home_provider.dart';
import 'package:stylo/providers/navigation_provider.dart';
import 'package:stylo/shared_preferences/shared_preferences_helper.dart';
import 'package:stylo/ui/account/about_app_screen.dart';

import 'package:stylo/ui/account/contact_with_us_screen.dart';
import 'package:stylo/ui/account/language_screen.dart';
import 'package:stylo/ui/account/personal_information_screen.dart';
import 'package:stylo/ui/account/terms_and_rules_Screen.dart';
import 'package:stylo/ui/my_ads/my_ads_screen.dart';

import 'package:stylo/ui/favourite/favourite_screen.dart';

import 'package:stylo/ui/home/home_screen.dart';

import 'package:stylo/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stylo/custom_widgets/safe_area/page_container.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'package:stylo/providers/auth_provider.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:stylo/providers/terms_provider.dart';
import 'package:stylo/utils/error.dart';

class AppDrawer extends StatelessWidget {
  double _width, _height;

  AuthProvider _authProvider ;
  HomeProvider _homeProvider ;

  Widget _buildAppDrawer(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    _authProvider = Provider.of<AuthProvider>(context);
    _homeProvider = Provider.of<HomeProvider>(context);
    return Container(


      color: mainAppColor,
      padding: EdgeInsets.only(top: 70, bottom: 30, left: 10, right:10),
      width: _width,

      child:  ListView(
        padding: EdgeInsets.zero,

        children: <Widget>[

          ListTile(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen()));
            },
            dense:true,
            leading:Image.asset('assets/images/home.png',),
            title: Text(_homeProvider.currentLang=="ar"?"الرئيسية":"Home",style: TextStyle(
                color: Colors.white,fontSize: 16,fontFamily: "Cairo"
            ),),
          ),

          Padding(padding: EdgeInsets.all(5)),



          ListTile(
            onTap: ()=>    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LanguageScreen())),
            dense:true,
            leading:Icon(FontAwesomeIcons.language,color: accentColor,size: 20,),
            title: Text( AppLocalizations.of(context).translate("language"),style: TextStyle(
                color: Colors.white,fontSize: 16
            ),),
          ),

          (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):Padding(padding: EdgeInsets.all(5)),

          (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
            onTap: ()=>    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PersonalInformationScreen()))
            ,

            dense:true,
            leading: Image.asset('assets/images/edit.png'),
            title: Text(AppLocalizations.of(context).translate("personal_info"),style: TextStyle(
                color: Colors.white,fontSize: 16
            ),),
          ),


          (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):Padding(padding: EdgeInsets.all(5)),



          (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
            onTap: ()=>    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyAdsScreen())),
            dense:true,
            leading: Image.asset('assets/images/adds.png'),
            title: Text( AppLocalizations.of(context).translate("my_ads"),style: TextStyle(
                color: Colors.white,fontSize: 15
            ),),
          ),



          (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
            onTap: ()=>    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyAds2Screen())),
            dense:true,
            leading: Image.asset('assets/images/adds.png'),
            title: Text( _homeProvider.currentLang=="ar"?"طلباتي":"My orders",style: TextStyle(
                color: Colors.white,fontSize: 15
            ),),
          ),



          (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):ListTile(
            onTap: ()=>    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationScreen())),
            dense:true,
            leading: Image.asset('assets/images/adds.png'),
            title: FutureBuilder<String>(
                future: Provider.of<HomeProvider>(context,
                    listen: false)
                    .getUnreadNotify() ,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Center(
                        child: SpinKitFadingCircle(color: mainAppColor),
                      );
                    case ConnectionState.active:
                      return Text('');
                    case ConnectionState.waiting:
                      return Center(
                        child: SpinKitFadingCircle(color: mainAppColor),
                      );
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Error(
                          //  errorMessage: snapshot.error.toString(),
                          errorMessage: AppLocalizations.of(context).translate('error'),
                        );
                      } else {
                        return  Row(
                          children: <Widget>[
                            Text( AppLocalizations.of(context).translate("notifications"),style: TextStyle(
                                color: Colors.white,fontSize: 15
                            ),),
                            Padding(padding: EdgeInsets.all(3)),
                            Container(
                              alignment: Alignment.center,
                              width: 20,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red),

                              child: snapshot.data!="0"?Container(
                                  margin: EdgeInsets.symmetric(horizontal: _width *0.04),
                                  child: Text( snapshot.data.toString(),style: TextStyle(
                                      color: Colors.white,fontSize: 15,height: 1.6
                                  ),)):Text("",style: TextStyle(height: 0),),
                            ),
                          ],
                        );
                      }
                  }
                  return Center(
                    child: SpinKitFadingCircle(color: mainAppColor),
                  );
                }),
          ),


          (_authProvider.currentUser==null)?Text("",style: TextStyle(height: 0),):Padding(padding: EdgeInsets.all(5)),





          ListTile(
            onTap: ()=>    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AboutAppScreen())),
            dense:true,
            leading: Image.asset('assets/images/about.png',),
            title: Text( AppLocalizations.of(context).translate("about_app"),style: TextStyle(
                color: Colors.white,fontSize: 16
            ),),
          ),

          Padding(padding: EdgeInsets.all(5)),


          ListTile(
            onTap: ()=>    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TermsAndRulesScreen())),
            dense:true,
            leading: Image.asset('assets/images/conditions.png'),
            title: Text( AppLocalizations.of(context).translate("rules_and_terms"),style: TextStyle(
                color: Colors.white,fontSize: 16
            ),),
          ),


          Padding(padding: EdgeInsets.all(5)),


          ListTile(
            onTap: ()=>    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContactWithUsScreen())),
            dense:true,
            leading: Image.asset('assets/images/call.png'),
            title: Text( AppLocalizations.of(context).translate("contact_us"),style: TextStyle(
                color: Colors.white,fontSize: 16
            ),),
          ),


          Padding(padding: EdgeInsets.all(5)),

          (_authProvider.currentUser==null)?ListTile(
            onTap: ()=>    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginScreen())),
            dense:true,
            leading:Image.asset('assets/images/logout.png'),
            title: Text( AppLocalizations.of(context).translate("login"),style: TextStyle(
                color: Colors.white,fontSize: 16
            ),),
          ):ListTile(
            dense:true,
            leading:Image.asset('assets/images/logout.png'),
            title: Text( AppLocalizations.of(context).translate('logout'),style: TextStyle(
                color: Colors.white,fontSize: 16
            ),),
            onTap: (){
              showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (_) {
                    return LogoutDialog(
                      alertMessage:
                      AppLocalizations.of(context).translate('want_to_logout'),
                      onPressedConfirm: () {
                        Navigator.pop(context);
                        SharedPreferencesHelper.remove("user");

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomeScreen()));
                        _authProvider.setCurrentUser(null);
                      },
                    );
                  });
            },
          ),









        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return _buildAppDrawer(context);
  }
}
