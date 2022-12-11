import 'package:flutter/cupertino.dart';
import 'package:stylo/custom_widgets/dialogs/location_dialog.dart';
import 'package:stylo/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stylo/custom_widgets/ad_item/ad_item.dart';
import 'package:stylo/custom_widgets/no_data/no_data.dart';
import 'package:stylo/custom_widgets/safe_area/page_container.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'dart:math' as math;
import 'package:stylo/models/ad.dart';
import 'package:stylo/providers/favourite_provider.dart';
import 'package:stylo/providers/home_provider.dart';

import 'package:stylo/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:stylo/utils/error.dart';


import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stylo/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:stylo/custom_widgets/safe_area/page_container.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'package:stylo/models/commission_app.dart';
import 'package:stylo/providers/auth_provider.dart';
import 'package:stylo/providers/commission_app_provider.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:stylo/providers/home_provider.dart';
import 'package:stylo/utils/error.dart';
import 'package:stylo/custom_widgets/buttons/custom_button.dart';

import 'package:stylo/providers/navigation_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
  with TickerProviderStateMixin{

  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();


  HomeProvider _homeProvider;



  String omar="";




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();


  }








  Widget _buildBodyItem() {


    return Container(
      width: _width,
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

      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),


              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/mqs.png',

                ),
              ),


                SizedBox(height: 20,),
              Container(
                alignment: Alignment.center,
                child: Text(_homeProvider.currentLang=="ar"?"أطلب خياطك عندك":"ask for your tailor",style: TextStyle(color: mainAppColor,fontWeight: FontWeight.bold,fontSize: 21),),
              ),
              SizedBox(height: 10,),
              Container(
                alignment: Alignment.center,
                child: Text(_homeProvider.currentLang=="ar"?"أطلب الان خياطك لحد عندك بأسعار مناسبة جدا لك":"Order now for your tailor to you at very reasonable prices for you",style: TextStyle(color: hintColor,fontSize: 16),),
              ),
              SizedBox(height: 30,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: _height * 0.04),
                height: 1,color: hintColor,),
              SizedBox(height: 30,),
              Container(
                margin: EdgeInsets.symmetric(horizontal: _height * 0.04),
                child: Row(
                  children: <Widget>[
                    Text(_homeProvider.currentLang=="ar"?"كيف يعني ؟":"how ?",style: TextStyle(color: accentColor,fontWeight: FontWeight.bold,fontSize: 21),),
                    Padding(padding: EdgeInsets.all(5)),
                    FutureBuilder<String>(
                        future: Provider.of<HomeProvider>(context,
                            listen: false)
                            .getBanner() ,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Center(
                                child: SpinKitFadingCircle(color: Colors.black),
                              );
                            case ConnectionState.active:
                              return Text('');
                            case ConnectionState.waiting:
                              return Center(
                                child: SpinKitFadingCircle(color: Colors.black),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Error(
                                  //  errorMessage: snapshot.error.toString(),
                                  errorMessage: AppLocalizations.of(context).translate('error'),
                                );
                              } else {


                                return  Container(
                                  padding: EdgeInsets.only(top: 5),
                                  child: GestureDetector(
                                    child: Text("مشاهدة الكتالوج"),
                                    onTap: (){
                                      launch(snapshot.data);
                                    },
                                  ),
                                );
                              }
                          }
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        })
                  ],
                ),
              ),

              SizedBox(height: 30,),

              Container(
                margin: EdgeInsets.symmetric(horizontal: _height * 0.04),
                child: Column(
                  children: <Widget>[

                    FutureBuilder<String>(
                        future: Provider.of<HomeProvider>(context,
                            listen: false)
                            .getOne() ,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Center(
                                child: SpinKitFadingCircle(color: Colors.black),
                              );
                            case ConnectionState.active:
                              return Text('');
                            case ConnectionState.waiting:
                              return Center(
                                child: SpinKitFadingCircle(color: Colors.black),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Error(
                                  //  errorMessage: snapshot.error.toString(),
                                  errorMessage: AppLocalizations.of(context).translate('error'),
                                );
                              } else {


                                return  ListTile(
                                  leading: Image.asset("assets/images/one.png"),
                                  title: Text(snapshot.data),
                                );
                              }
                          }
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        }),




                    FutureBuilder<String>(
                        future: Provider.of<HomeProvider>(context,
                            listen: false)
                            .getTwo(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Center(
                                child: SpinKitFadingCircle(color: Colors.black),
                              );
                            case ConnectionState.active:
                              return Text('');
                            case ConnectionState.waiting:
                              return Center(
                                child: SpinKitFadingCircle(color: Colors.black),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Error(
                                  //  errorMessage: snapshot.error.toString(),
                                  errorMessage: AppLocalizations.of(context).translate('error'),
                                );
                              } else {


                                return  ListTile(
                                  leading: Image.asset("assets/images/two.png"),
                                  title: Text(snapshot.data),
                                );
                              }
                          }
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        }),


                    FutureBuilder<String>(
                        future: Provider.of<HomeProvider>(context,
                            listen: false)
                            .getThree() ,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Center(
                                child: SpinKitFadingCircle(color: Colors.black),
                              );
                            case ConnectionState.active:
                              return Text('');
                            case ConnectionState.waiting:
                              return Center(
                                child: SpinKitFadingCircle(color: Colors.black),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Error(
                                  //  errorMessage: snapshot.error.toString(),
                                  errorMessage: AppLocalizations.of(context).translate('error'),
                                );
                              } else {


                                return  ListTile(
                                  leading: Image.asset("assets/images/three.png"),
                                  title: Text(snapshot.data),
                                );
                              }
                          }
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        }),
                  ],
                ),
              ),


              SizedBox(
                height: 30,
              ),

           CustomButton(
             btnLbl: _homeProvider.currentLang=="ar"?"متابعة":"Follow",
             onPressedFunction: (){
               Navigator.push(
                   context,
                   MaterialPageRoute(
                       builder: (context) => LocationDialog()));
             },
           ),







            ],
          ),
        ),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _homeProvider = Provider.of<HomeProvider>(context);
    return PageContainer(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Image.asset("assets/images/back.png"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Image.asset("assets/images/toplogo.png"),
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