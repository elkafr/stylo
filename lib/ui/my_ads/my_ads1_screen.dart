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
import 'package:stylo/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:stylo/utils/error.dart';
import 'package:stylo/ui/add_ad/widgets/add_ad_bottom_sheet.dart';

import 'dart:io';

import 'package:stylo/ui/auth/login_screen.dart';
import 'package:stylo/ui/home/home_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stylo/custom_widgets/buttons/custom_button.dart';
import 'package:stylo/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:stylo/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:stylo/custom_widgets/dialogs/confirmation_dialog.dart';
import 'package:stylo/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:stylo/custom_widgets/safe_area/page_container.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'package:stylo/models/category.dart';
import 'package:stylo/models/city.dart';
import 'package:stylo/models/country.dart';
import 'package:stylo/networking/api_provider.dart';
import 'package:stylo/providers/auth_provider.dart';
import 'package:stylo/providers/home_provider.dart';
import 'package:stylo/providers/navigation_provider.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:stylo/utils/commons.dart';
import 'package:stylo/utils/urls.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:stylo/models/marka.dart';
import 'package:stylo/models/model.dart';
import 'package:stylo/providers/location_state.dart';
import 'package:path/path.dart' as Path;
import 'dart:math' as math;

import 'package:stylo/providers/commission_app_provider.dart';
import 'package:stylo/models/commission_app.dart';


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'dart:math' as math;
class MyAds1Screen extends StatefulWidget {
  @override
  _MyAds1ScreenState createState() => _MyAds1ScreenState();
}

class _MyAds1ScreenState extends State<MyAds1Screen>  with TickerProviderStateMixin{
  double _height = 0 , _width = 0;
  NavigationProvider _navigationProvider;
  AnimationController _animationController;
  HomeProvider _homeProvider;
  AuthProvider _authProvider;
  ApiProvider _apiProvider =ApiProvider();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _adsdetails="";
  String _adsModel="";

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
              height: _height - 390,
              width: _width,
              child:  FutureBuilder<List<Ad>>(
                  future:  Provider.of<MyAdsProvider>(context,
                      listen: true)
                      .getMyAdsList1() ,
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
                                      height: 130,
                                      width: _width,
                                      child: InkWell(
                                          onTap: (){},
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: _width * 0.04,
                                                    right: _width * 0.04,
                                                    bottom: _width * 0.01),
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
                                                child:    Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical:
                                                      _width * 0.04,
                                                      horizontal:
                                                      _width * 0.04),
                                                  width: _width,
                                                  child: Row(
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        child: _homeProvider.omarKey==snapshot.data[index].adsId?Icon(Icons.check_circle):Icon(Icons.check_circle_outline),
                                                        onTap: (){
                                                          _homeProvider.setOmarKey(snapshot.data[index].adsId);
                                                          _adsModel=snapshot.data[index].adsModel;
                                                        },
                                                      ),

                                                      Padding(padding: EdgeInsets.all(5)),
                                                      Text(
                                                        snapshot.data[index].adsModel,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16,
                                                            height: 1.4),
                                                        maxLines: 20,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),





                                            ],
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

          ),



         Container(
           height: 300,
           child:  Form(
             key: _formKey,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 SizedBox(
                   height: 30,
                 ),



                 Container(
                   margin: EdgeInsets.symmetric(horizontal: _height * 0.04),
                   child: Text(_homeProvider.currentLang=='ar'?"لارسال طلب تفصيل اختار واحد من مقاساتك فى الاعلي واكتب تفاصيل الطلب":"Booking time",style: TextStyle(color: accentColor,fontWeight: FontWeight.bold,fontSize: 15),),
                 ),

                 Padding(padding: EdgeInsets.all(5)),

                 CustomTextFormField(
                   maxLines: 3,
                   onChangedFunc: (text){
                     _adsdetails = text;
                   },
                   hintTxt: AppLocalizations.of(context).translate('message'),
                 ),


                 CustomButton(
                   btnLbl:_homeProvider.currentLang=="ar"?"ارسال الطلب":"Send request",
                   onPressedFunction: () async {
                     if (_formKey.currentState.validate()) {

                       if(_authProvider.currentUser==null){
                         Commons.showToast(context,
                             message:_homeProvider.currentLang=="ar"?"يجب تسجيل الدخول اولا":"you must login before", color: Colors.red);

                         Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (context) => LoginScreen()));

                       }else{

    if(_adsdetails!="" && _adsModel!=""){

    FocusScope.of(context).requestFocus(FocusNode());
    setState(() => _isLoading = true);

    FormData formData = new FormData.fromMap({
    "user_id": _authProvider.currentUser.userId,
    "ads_details": _adsdetails,
    "ads_model": _adsModel,
    });
    final results = await _apiProvider
        .postWithDio(Urls.ADD_AD_URL1 +
    "?api_lang=${_authProvider.currentLang}",
    body: formData);
    setState(() => _isLoading = false);


    if (results['response'] == "1") {
    showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
    return ConfirmationDialog(
    title: _homeProvider.currentLang=="ar"?"تم ارسال الطلب بنجاح":"The request has been sent successfully",
    message:
    AppLocalizations.of(context).translate(
    'ad_published_and_manage_my_ads'),
    );
    });


    Future.delayed(const Duration(seconds: 5), () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => HomeScreen()));
    });
    } else {
    Commons.showError(context, results["message"]);
    }


    }else{
      Commons.showError(context,"فضلا ملئ  الخانات");
    }






                       }


                     }
                   },
                 ),
               ],
             ),
           ),
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
    _authProvider = Provider.of<AuthProvider>(context);
    _homeProvider = Provider.of<HomeProvider>(context);

    return PageContainer(
      child: Scaffold(

          appBar: AppBar(
            leading: IconButton(
              icon: Image.asset("assets/images/back.png"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text("مقاساتي"),
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