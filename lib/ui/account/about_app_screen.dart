import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'package:stylo/providers/auth_provider.dart';
import 'package:stylo/utils/error.dart';
import 'package:stylo/custom_widgets/safe_area/page_container.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:stylo/providers/about_app_provider.dart';
import 'dart:math' as math;

class AboutAppScreen extends StatefulWidget {
  @override
  _AboutAppScreenState createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
double _height = 0 , _width = 0;




Widget _buildBodyItem(){
  return SingleChildScrollView(
    child: Container(
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
      height: _height-(_height*.07),
      width: _width,
      child: Column(
     
        children: <Widget>[
          SizedBox(
            height: 40,
          ),

          Image.asset(
            'assets/images/logo.png',color: mainAppColor,

          ),
          SizedBox(
            height: 15,
          ),
               Expanded(
                 child: FutureBuilder<String>(
                    future: Provider.of<AboutAppProvider>(context,
                            listen: false)
                        .getAboutApp() ,
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
                              errorMessage:  AppLocalizations.of(context).translate('error'),
                            );
                          } else {
                       return    Container(
             margin: EdgeInsets.symmetric(horizontal: _width *0.04),
             child: Html(data: snapshot.data));
                          }
                      }
                      return Center(
                        child: SpinKitFadingCircle(color: mainAppColor),
                      );
                    }),
               )
 
          
            
   

            
        ],
      ),
    ),
  );
}

@override
  Widget build(BuildContext context) {
    _height =
        _height =  MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    return PageContainer(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Image.asset("assets/images/back.png"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(AppLocalizations.of(context).translate('about_app'),),
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