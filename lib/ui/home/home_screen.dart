import 'package:stylo/ui/auth/login_screen.dart';
import 'package:stylo/ui/add_ad/widgets/add_ad_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stylo/shared_preferences/shared_preferences_helper.dart';
import 'package:stylo/ui/drower/drower_screen.dart';
import 'package:stylo/ui/home/home_map.dart';
import 'package:flutter/services.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'package:stylo/providers/auth_provider.dart';
import 'dart:math' as math;
import 'package:stylo/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:stylo/providers/home_provider.dart';

import 'package:provider/provider.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:stylo/utils/commons.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

AuthProvider _authProvider;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double _height = 0, _width = 0;
  bool isDrawerOpen = false;
String _searchKey = '';
HomeProvider _homeProvider;
bool _initialRun = true;
  String _lang;
bool _isLoading = false;



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


Future<Null> _checkEnd() async {





}






@override
void didChangeDependencies() {
  super.didChangeDependencies();
  if (_initialRun) {
    _homeProvider = Provider.of<HomeProvider>(context);
    _authProvider = Provider.of<AuthProvider>(context);
    _initialRun = false;

  }
}


  Future<void> _getLanguage() async {
    String language = await SharedPreferencesHelper.getUserLang();
    setState(() {
      _lang = language;
    });
  }
  Widget _customAppBar() {
    return Container(
      alignment: Alignment.center,
     padding: EdgeInsets.only(top: 2,bottom: 4,right: 10),

      child:    Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          isDrawerOpen
              ? Text("")
              : GestureDetector(
              child:
              _lang == 'ar' ?
              Image.asset( 'assets/images/menu.png', fit: BoxFit.contain,)

                  : Transform.rotate(
                angle: -180 * math.pi / 180,
                child:  Image.asset(
                  'assets/images/menu.png',
                  fit: BoxFit.contain,
                ),
              ),
              onTap: () {
                setState(() {
                  xOffset = (_lang == 'ar')? -200 : 290 ;
                  yOffset = 80;
                  scaleFactor = 0.8;
                  isDrawerOpen = true;
                });
              }),
          Spacer(
            flex: 2,
          ),
          Container(
            alignment: Alignment.center,


            child: Image.asset("assets/images/toplogo.png"),
          ),
          Spacer(
            flex: 3,
          ),
        ],
      ),
    );
  }
  




  @override
  void initState() {
    super.initState();


    _getLanguage();



  }

  @override
  Widget build(BuildContext context) {

    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              (isDrawerOpen == false) ? Brightness.dark : Brightness.light),
      child: Scaffold(

        body: Stack(

          children: [
            AppDrawer(),
           
            AnimatedContainer(
              transform: Matrix4.translationValues(xOffset, yOffset, 0)
                ..scale(scaleFactor)
                ..rotateY(isDrawerOpen ? -0.5 : 0),
              duration: Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: Colors.white,
                //borderRadius: BorderRadius.circular(isDrawerOpen?20:0.0)
              ),
              child: Container(
              color: mainAppColor,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    SizedBox(
                      height: 25,
                    ),
                   _customAppBar(),
                    Container(

                      height: _height * 0.90,
                      width: _width,
                      child: Stack(children: [


                        GestureDetector(
                          child: HomeMap(),
                          onTap: (){
                            setState(() {
                              xOffset = 0;
                              yOffset = 0;
                              scaleFactor = 1;
                              isDrawerOpen = false;
                            });
                          },
                        ),






                      ]),
                    ),
                  ],
                ),
              ),
            )
          ],


        ),




      ),
    );
  }
  
}