import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stylo/custom_widgets/buttons/custom_button.dart';
import 'package:stylo/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:stylo/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:stylo/custom_widgets/drop_down_list_selector/drop_down_list_selector.dart';
import 'package:stylo/custom_widgets/safe_area/page_container.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'package:stylo/models/country.dart';
import 'package:stylo/models/user.dart';
import 'package:stylo/networking/api_provider.dart';
import 'package:stylo/providers/auth_provider.dart';
import 'package:stylo/providers/home_provider.dart';
import 'package:stylo/shared_preferences/shared_preferences_helper.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:stylo/utils/commons.dart';
import 'package:stylo/utils/urls.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class EditPersonalInfoScreen extends StatefulWidget {
  @override
  _EditPersonalInfoScreenState createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> with ValidationMixin {
  double _height = 0 , _width = 0;
  String _userName = '',_userPhone = '',_userEmail ='';
  AuthProvider _authProvider;
  bool _initialRun = true;
  bool _isLoading = false;
  Country _selectedCountry;
  bool _initSelectedCountry = true;
  Future<List<Country>> _countryList;
  HomeProvider _homeProvider;
  final _formKey = GlobalKey<FormState>();
  ApiProvider _apiProvider = ApiProvider();



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _authProvider = Provider.of<AuthProvider>(context);
      _homeProvider = Provider.of<HomeProvider>(context);

      _countryList = _homeProvider.getCountryList();
      _userName = _authProvider.currentUser.userName;
      _userPhone = _authProvider.currentUser.userPhone;
      _userEmail = _authProvider.currentUser.userEmail;
      _initialRun = false;
    }
  }
  Widget _buildBodyItem(){
    return SingleChildScrollView(
      child: Container(
        height: _height,
        width: _width,
        child: Form(
          key: _formKey,
          child: Column(

            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              CustomTextFormField(
                initialValue: _userName,
                prefixIconIsImage: true,
                prefixIconImagePath: 'assets/images/user.png',
                hintTxt:AppLocalizations.of(context).translate('user_name'),
                validationFunc:validateUserName,
                onChangedFunc: (text) {
                  _userName = text;
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: _height *0.02),
                child: CustomTextFormField(
                  initialValue: _userPhone,
                  prefixIconIsImage: true,
                  prefixIconImagePath: 'assets/images/call.png',
                  hintTxt:  AppLocalizations.of(context).translate('phone_no'),
                  validationFunc: validateUserPhone,
                  onChangedFunc: (text) {
                    _userPhone = text;
                  },
                ),
              ),
              CustomTextFormField(
                initialValue: _userEmail,
                prefixIconIsImage: true,
                prefixIconImagePath: 'assets/images/mail.png',
                hintTxt: AppLocalizations.of(context).translate('email'),
                validationFunc:  validateUserEmail,
                onChangedFunc: (text) {
                  _userEmail = text;
                },
              ),



              SizedBox(
                height: _height *0.02,
              ),

              CustomButton(
                btnLbl: AppLocalizations.of(context).translate('save'),
                btnColor: mainAppColor,
                onPressedFunction: () async {
                  if (_formKey.currentState.validate() ){
                    setState(() => _isLoading = true);
                    FormData formData = new FormData.fromMap({
                      "user_id": _authProvider.currentUser.userId,
                      "user_name":  _userName,
                      "user_phone" : _userPhone,
                      "user_email":  _userEmail,



                    });
                    final results = await _apiProvider
                        .postWithDio(Urls.PROFILE_URL + "?api_lang=${_authProvider.currentLang}", body: formData);
                    setState(() => _isLoading = false);

                    if (results['response'] == "1") {
                      _authProvider
                          .setCurrentUser(User.fromJson(results["user"]));
                      SharedPreferencesHelper.save(
                          "user", _authProvider.currentUser);
                      Commons.showToast(context,message: results["message"] );
                      Navigator.pop(context);
                    } else {
                      Commons.showError(context, results["message"]);
                    }
                  }

                },
              ),
              Spacer(),


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


    final appBar = AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: mainAppColor,
      leading: null,
      centerTitle: true,
      title: Text(AppLocalizations.of(context).translate('edit_info'),style: TextStyle(fontSize: 18),),
      actions: <Widget>[
        GestureDetector(
          child: Icon(Icons.arrow_forward,color: Colors.white,size: 35,),
          onTap: (){
            Navigator.pop(context);
          },
        ),
        Padding(padding: EdgeInsets.all(5)),

      ],

    );

    return PageContainer(
      child: Scaffold(
          appBar: appBar,
          body: Stack(
            children: <Widget>[
              _buildBodyItem(),


              _isLoading
                  ? Center(
                child:SpinKitFadingCircle(color: mainAppColor),
              )
                  :Container()
            ],
          )),
    );
  }
}