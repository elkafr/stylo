import 'package:flutter/material.dart';
import 'package:stylo/models/ad.dart';
import 'package:stylo/models/user.dart';
import 'package:stylo/networking/api_provider.dart';
import 'package:stylo/providers/auth_provider.dart';
import 'package:stylo/utils/urls.dart';

  class MyAdsProvider extends ChangeNotifier {
    ApiProvider _apiProvider = ApiProvider();
  User _currentUser;
  String _currentLang;

  void update(AuthProvider authProvider) {
    _currentUser = authProvider.currentUser;
    _currentLang =  authProvider.currentLang;
  }
     Future<List<Ad>> getMyAdsList() async {

    final response = await _apiProvider.get(
        Urls.MY_ADS_URL + 'user_id=${_currentUser.userId}&page=1&api_lang=$_currentLang' );
    List<Ad> adsList = List<Ad>();
    if (response['response'] == '1') {
      Iterable iterable = response['requests'];
      adsList = iterable.map((model) => Ad.fromJson(model)).toList();
    }

    return adsList;
  }


    Future<List<Ad>> getMyAdsList1() async {

      final response = await _apiProvider.get(
          Urls.MY_ADS_URL1 + 'user_id=${_currentUser.userId}&page=1&api_lang=$_currentLang' );
      List<Ad> adsList = List<Ad>();
      if (response['response'] == '1') {
        Iterable iterable = response['requests'];
        adsList = iterable.map((model) => Ad.fromJson(model)).toList();
      }

      return adsList;
    }

    Future<List<Ad>> getMyAdsList2() async {

      final response = await _apiProvider.get(
          Urls.MY_ADS_URL2 + 'user_id=${_currentUser.userId}&page=1&api_lang=$_currentLang' );
      List<Ad> adsList = List<Ad>();
      if (response['response'] == '1') {
        Iterable iterable = response['requests'];
        adsList = iterable.map((model) => Ad.fromJson(model)).toList();
      }

      return adsList;
    }


  }