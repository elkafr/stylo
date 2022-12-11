import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stylo/custom_widgets/no_data/no_data.dart';
import 'package:stylo/custom_widgets/safe_area/page_container.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'package:stylo/models/ad.dart';
import 'package:stylo/providers/auth_provider.dart';
import 'package:stylo/providers/my_ads_provider.dart';
import 'package:stylo/providers/navigation_provider.dart';
import 'package:stylo/ui/my_ads/widgets/my_ad_item.dart';
import 'package:stylo/ui/my_ads/widgets/my_ad_item2.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:stylo/utils/error.dart';
import 'package:stylo/ui/add_ad/widgets/add_ad_bottom_sheet.dart';

import 'dart:math' as math;
class MyAds2Screen extends StatefulWidget {
  @override
  _MyAds2ScreenState createState() => _MyAds2ScreenState();
}

class _MyAds2ScreenState extends State<MyAds2Screen>  with TickerProviderStateMixin{
  double _height = 0 , _width = 0;
  NavigationProvider _navigationProvider;
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  Widget _buildBodyItem(){
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
          Container(
              height: _height - 80,
              width: _width,
              child:  FutureBuilder<List<Ad>>(
                  future:  Provider.of<MyAdsProvider>(context,
                      listen: true)
                      .getMyAdsList2() ,
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
                          if (snapshot.data.length > 0) {
                            return     ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var count = snapshot.data.length;
                                  var animation = Tween(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                      parent: _animationController,
                                      curve: Interval((1 / count) * index, 1.0,
                                          curve: Curves.fastOutSlowIn),
                                    ),
                                  );
                                  _animationController.forward();
                                  return Container(
                                      height: 180,
                                      width: _width,
                                      child: InkWell(
                                          onTap: (){},
                                          child: MyAdItem2(
                                            ad: snapshot.data[index],
                                            animation: animation,
                                            animationController: _animationController,
                                          )));
                                }
                            );
                          } else {
                            return NoData(message: AppLocalizations.of(context).translate('no_results'));
                          }
                        }
                    }
                    return Center(
                      child: SpinKitFadingCircle(color: mainAppColor),
                    );
                  })

          )
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _navigationProvider = Provider.of<NavigationProvider>(context);
    return PageContainer(
      child: Scaffold(

          appBar: AppBar(
            leading: IconButton(
              icon: Image.asset("assets/images/back.png"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text("طلباتي"),
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