import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stylo/custom_widgets/buttons/custom_button.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'package:stylo/models/ad.dart';
import 'package:stylo/networking/api_provider.dart';
import 'package:stylo/providers/auth_provider.dart';

import 'package:stylo/utils/app_colors.dart';
import 'package:stylo/utils/commons.dart';
import 'package:stylo/utils/urls.dart';
import 'package:provider/provider.dart';

class MyAdItem extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  final Ad ad;

  const MyAdItem({Key key, this.animationController, this.animation, this.ad})
      : super(key: key);
  @override
  _MyAdItemState createState() => _MyAdItemState();
}

class _MyAdItemState extends State<MyAdItem> {
  bool _isLoading = false;
  ApiProvider _apiProvider = ApiProvider();
  AuthProvider _authProvider;
  @override
  Widget build(BuildContext context) {
    _authProvider = Provider.of<AuthProvider>(context);
    return AnimatedBuilder(
        animation: widget.animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: widget.animation,
              child: new Transform(
                  transform: new Matrix4.translationValues(
                      0.0, 50 * (1.0 - widget.animation.value), 0.0),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                              left: constraints.maxWidth * 0.04,
                              right: constraints.maxWidth * 0.04,
                              bottom: constraints.maxHeight * 0.1),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(
                              color: hintColor.withOpacity(0.4),
                            ),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                    constraints.maxHeight * 0.04,
                                    horizontal:
                                    constraints.maxWidth * 0.04),
                                width: constraints.maxWidth,
                                child: Text(
                                  "#100"+widget.ad.adsId,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      height: 1.4),
                                  maxLines: 1,
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                    constraints.maxHeight * 0.04,
                                    horizontal:
                                    constraints.maxWidth * 0.04),
                                width: constraints.maxWidth,
                                child:  Row(
                                  children: <Widget>[

                                    Image.asset("assets/images/date.png",color: hintColor,),
                                    Padding(padding: EdgeInsets.all(6)),
                                    Text(
                                      _authProvider.currentLang=="ar"?"?????????? ?????????? : ":"Book date : ",
                                      style: TextStyle(
                                          color: hintColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          height: 1.4),
                                      maxLines: 1,
                                    ),
                                    Text(
                                       widget.ad.adsCatName,
                                      style: TextStyle(
                                          color: hintColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          height: 1.4),
                                      maxLines: 1,
                                    )
                                  ],
                                ),
                              ),



                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                    constraints.maxHeight * 0.04,
                                    horizontal:
                                    constraints.maxWidth * 0.04),
                                width: constraints.maxWidth,
                                child:  Row(
                                  children: <Widget>[
                                    Image.asset("assets/images/time.png",color: hintColor,),
                                    Padding(padding: EdgeInsets.all(6)),
                                    Text(
                                      _authProvider.currentLang=="ar"?"?????? ?????????? : ":"Book time : ",
                                      style: TextStyle(
                                          color: hintColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          height: 1.4),
                                      maxLines: 1,
                                    ),
                                    Text(
                                      widget.ad.adsSubCatName,
                                      style: TextStyle(
                                          color: hintColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          height: 1.4),
                                      maxLines: 1,
                                    )
                                  ],
                                ),
                              ),



                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                    constraints.maxHeight * 0.04,
                                    horizontal:
                                    constraints.maxWidth * 0.04),
                                width: constraints.maxWidth,
                                child:  Row(
                                  children: <Widget>[

                                    Image.asset("assets/images/date.png",color: hintColor,),
                                    Padding(padding: EdgeInsets.all(6)),
                                    Text(
                                      _authProvider.currentLang=="ar"?"???????? ?????????? : ":"Book state : ",
                                      style: TextStyle(
                                          color: hintColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          height: 1.4),
                                      maxLines: 1,
                                    ),
                                    widget.ad.adsActive=="1"?Text(
                                      "??????????",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          height: 1.4),
                                      maxLines: 1,
                                    ):Text(
                                      "??????????????????",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          height: 1.4),
                                      maxLines: 1,
                                    )
                                  ],
                                ),
                              ),


                            ],
                          ),
                        ),
                        _isLoading
                            ? Center(
                                child: SpinKitFadingCircle(color: mainAppColor),
                              )
                            : Container()
                      ],
                    );
                  })));
        });
  }
}
