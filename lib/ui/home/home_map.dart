import 'dart:io';
import 'package:stylo/custom_widgets/buttons/custom_button.dart';
import 'package:stylo/custom_widgets/dialogs/location_dialog.dart';
import 'package:stylo/shared_preferences/shared_preferences_helper.dart';
import 'package:stylo/ui/favourite/favourite_screen.dart';
import 'package:stylo/ui/home/widgets/slider_images.dart';
import 'package:stylo/ui/my_ads/my_ads1_screen.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stylo/custom_widgets/ad_item/ad_item.dart';
import 'package:stylo/custom_widgets/no_data/no_data.dart';
import 'package:stylo/custom_widgets/safe_area/page_container.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'package:stylo/models/user.dart';
import 'package:stylo/models/ad.dart';
import 'package:stylo/models/category.dart';
import 'package:stylo/models/city.dart';
import 'package:stylo/models/marka.dart';
import 'package:stylo/models/model.dart';
import 'package:stylo/providers/home_provider.dart';
import 'package:stylo/providers/navigation_provider.dart';

import 'package:stylo/ui/home/widgets/category_item.dart';
import 'package:stylo/ui/home/widgets/map_widget.dart';

import 'package:stylo/utils/app_colors.dart';
import 'package:stylo/ui/account/account_screen.dart';
import 'package:provider/provider.dart';
import 'package:stylo/utils/error.dart';
import 'package:stylo/providers/navigation_provider.dart';
import 'package:stylo/providers/auth_provider.dart';
import 'package:stylo/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:stylo/custom_widgets/MainDrawer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomeMap extends StatefulWidget {
  @override
  _HomeMapState createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> with TickerProviderStateMixin {
  double _height = 0, _width = 0;
  NavigationProvider _navigationProvider;
  Future<List<CategoryModel>> _categoryList;
  Future<List<CategoryModel>> _subList;
  bool _initialRun = true;
  HomeProvider _homeProvider;
  AnimationController _animationController;
  AuthProvider _authProvider;

  Future<List<City>> _cityList;
  City _selectedCity;

  Future<List<Marka>> _markaList;
  Marka _selectedMarka;

  Future<List<Model>> _modelList;
  Model _selectedModel;

  CategoryModel _selectedSub;
  String _selectedCat;
  bool _isLoading = false;

  String _xx=null;


  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();

  void _iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void _firebaseCloudMessagingListeners() {
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android: android, iOS: ios);
    _flutterLocalNotificationsPlugin.initialize(platform);

    if (Platform.isIOS) _iOSPermission();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        _showNotification(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');

        Navigator.pushNamed(context, '/notification_screen');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');

        Navigator.pushNamed(context, '/notification_screen');
      },
    );
  }

  _showNotification(Map<String, dynamic> message) async {
    var android = new AndroidNotificationDetails(
      'channel id',
      "CHANNLE NAME",
      "channelDescription",
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await _flutterLocalNotificationsPlugin.show(
        0,
        message['notification']['title'],
        message['notification']['body'],
        platform);
  }


  Future<Null> _checkIsLogin() async {
    var userData = await SharedPreferencesHelper.read("user");
    if (userData != null) {
      _authProvider.setCurrentUser(User.fromJson(userData));
      _firebaseCloudMessagingListeners();
    }

  }




  @override
  void initState() {
    _animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    super.initState();

  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _homeProvider = Provider.of<HomeProvider>(context);
      _categoryList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:true ,catId: '0',catName:
      _homeProvider.currentLang=="ar"?"المميزة":"Featured",catImage: 'assets/images/all.png'),enableSub: false);


      _subList = _homeProvider.getSubList(enableSub: false,catId:_homeProvider.age!=''?_homeProvider.age:"6");

      _checkIsLogin();
      _cityList = _homeProvider.getCityList(enableCountry: false);
      _markaList = _homeProvider.getMarkaList();
      _modelList = _homeProvider.getModelList();
      _initialRun = false;
    }
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildBodyItem() {
    return Container(
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


        padding: EdgeInsets.all(0),
        children: <Widget>[




          Container(
              height: _height * 0.70,

              color: Color(0xffeef4f6),

               margin: EdgeInsets.all( _width*.06),
              child: SliderImages(),),


              Row(
                children: <Widget>[
                  Container(
                    width: _width*.50,
                    child:  CustomButton(
                      btnColor: mainAppColor,
                      btnLbl: _homeProvider.currentLang=="ar"?"أطلب خياط الان":"Request a tailor now",
                      onPressedFunction: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavouriteScreen()));
                      },
                    ),
                  ),


                  Container(
                    width: _width*.50,
                    child:  CustomButton(
                      btnColor: mainAppColor,
                      btnLbl: _homeProvider.currentLang=="ar"?"مقاساتي":"My sizes",
                      onPressedFunction: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyAds1Screen()));
                      },
                    ),
                  )


                ],
              )




        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _navigationProvider = Provider.of<NavigationProvider>(context);
    _authProvider = Provider.of<AuthProvider>(context);


    
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _navigationProvider = Provider.of<NavigationProvider>(context);

    return Container(
      height: _height,
      color: mainAppColor,
      child: _buildBodyItem(),
    );
  }
}
