

import 'package:stylo/ui/auth/code_activation_screen.dart';
import 'package:stylo/ui/account/active_account_screen.dart';
import 'package:stylo/ui/auth/login_screen.dart';
import 'package:stylo/ui/auth/new_password_screen.dart';
import 'package:stylo/ui/auth/phone_password_recovery_screen.dart';
import 'package:stylo/ui/auth/register_screen.dart';
import 'package:stylo/ui/bottom_navigation.dart/bottom_navigation_bar.dart';

import 'package:stylo/ui/my_ads/my_ads_screen.dart';


import 'package:stylo/ui/splash/splash_screen.dart';



final routes = {
  '/': (context) => SplashScreen(),
  '/login_screen':(context)=> LoginScreen(),
  '/phone_password_reccovery_screen' :(context) => PhonePasswordRecoveryScreen(),
  '/code_activation_screen':(context) => CodeActivationScreen(),
  '/active_account_screen':(context) => ActiveAccountScreen(),
 '/new_password_screen' :(context) => NewPasswordScreen(),
 '/register_screen':(context) => RegisterScreen(),
  '/navigation': (context) =>  BottomNavigation(),
  '/my_ads_screen':(context) =>MyAdsScreen(),



};
