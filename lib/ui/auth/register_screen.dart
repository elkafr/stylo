import 'package:stylo/ui/account/terms_and_rules_screen.dart';
import 'package:stylo/ui/auth/login_screen.dart';
import 'package:stylo/ui/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stylo/custom_widgets/buttons/custom_button.dart';
import 'package:stylo/custom_widgets/custom_selector/custom_selector.dart';
import 'package:stylo/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:stylo/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:stylo/custom_widgets/dialogs/confirmation_dialog.dart';
import 'package:stylo/custom_widgets/safe_area/page_container.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'package:stylo/networking/api_provider.dart';
import 'package:stylo/providers/auth_provider.dart';
import 'package:stylo/providers/register_provider.dart';
import 'package:stylo/providers/terms_provider.dart';
import 'package:stylo/ui/auth/widgets/select_country_bottom_sheet.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:stylo/utils/commons.dart';
import 'package:stylo/utils/urls.dart';
import 'package:provider/provider.dart';
import 'package:stylo/ui/account/active_account_screen.dart';
import 'dart:math' as math;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
  RegisterProvider _registerProvider;
  bool _initalRun = true;
  bool _isLoading = false;
  ApiProvider _apiProvider = ApiProvider();
  TermsProvider _termsProvider = TermsProvider();
  String _userName = '', _userPhone = '', _userEmail = '', _userPassword = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initalRun) {
      _registerProvider = Provider.of<RegisterProvider>(context);
      _registerProvider.getCountryList();
      _termsProvider.getTerms();
    }
  }

  Widget _buildBodyItem() {
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

      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(


            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),

                Container(

                  alignment: Alignment.center,

                  child:  Image.asset('assets/images/logo.png',height:_height *0.2 ,color: mainAppColor,),
                ),
                CustomTextFormField(
                  prefixIconIsImage: true,
                  prefixIconImagePath: 'assets/images/user.png',
                  hintTxt: AppLocalizations.of(context).translate('user_name'),
                  validationFunc: validateUserName,
                  onChangedFunc: (text) {
                    _userName = text;
                  },
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: _height * 0.02),
                  child: CustomTextFormField(
                    prefixIconIsImage: true,
                    prefixIconImagePath: 'assets/images/call.png',
                    hintTxt: AppLocalizations.of(context).translate('phone_no'),
                    validationFunc: validateUserPhone,
                    onChangedFunc: (text) {
                      _userPhone = text;
                    },
                  ),
                ),
                CustomTextFormField(
                  prefixIconIsImage: true,
                  prefixIconImagePath: 'assets/images/mail.png',
                  hintTxt:AppLocalizations.of(context).translate('email'),
                  validationFunc: validateUserEmail,
                  onChangedFunc: (text) {
                    _userEmail = text;
                  },
                ),

                SizedBox(height: 15,),

                Container(
                  margin: EdgeInsets.only(bottom: _height * 0.02),
                  child: CustomTextFormField(
                    isPassword: true,
                    prefixIconIsImage: true,
                    prefixIconImagePath: 'assets/images/key.png',
                    hintTxt: AppLocalizations.of(context).translate('password'),
                    validationFunc: validatePassword,
                    onChangedFunc: (text) {
                      _userPassword = text;
                    },
                  ),
                ),
                CustomTextFormField(
                  isPassword: true,
                  prefixIconIsImage: true,
                  prefixIconImagePath: 'assets/images/key.png',
                  hintTxt:  AppLocalizations.of(context).translate('confirm_password'),
                  validationFunc: validateConfirmPassword,
                ),
                Container(
                    margin: EdgeInsets.symmetric(
                        vertical: _height * 0.01, horizontal: _width * 0.07),
                    child: Row(
                      children: <Widget>[
                        Consumer<RegisterProvider>(
                            builder: (context, registerProvider, child) {
                              return GestureDetector(
                                onTap: () => registerProvider
                                    .setAcceptTerms(!registerProvider.acceptTerms),
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  child: registerProvider.acceptTerms
                                      ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 17,
                                  )
                                      : Container(),
                                  decoration: BoxDecoration(
                                    color: registerProvider.acceptTerms
                                        ? Color(0xffA8C21C)
                                        : Colors.white,
                                    border: Border.all(
                                      color: registerProvider.acceptTerms
                                          ? Color(0xffA8C21C)
                                          : hintColor,
                                    ),
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                ),
                              );
                            }),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: _width * 0.02),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TermsAndRulesScreen()));
                              },
                              child: RichText(

                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Cairo',
                                      color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(text:  AppLocalizations.of(context).translate('accept_to_all')),
                                    TextSpan(text: ' '),
                                    TextSpan(
                                        text: AppLocalizations.of(context).translate('rules_and_terms'),
                                        style:  TextStyle(
                                            decoration: TextDecoration.underline,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            fontFamily: 'Cairo',
                                            color: Color(0xffA8C21C))),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    )),
                CustomButton(
                  btnLbl: AppLocalizations.of(context).translate('make_account'),
                  onPressedFunction: () async {

                    if (_formKey.currentState.validate()) {

                        if (_registerProvider.acceptTerms) {
                          setState(() {
                            _isLoading = true;
                          });
                          final results =
                          await _apiProvider.post(Urls.REGISTER_URL, body: {
                            "user_name":_userName,
                            "user_phone": _userPhone,
                            "user_pass": _userPassword,
                            "user_pass_confirm":_userPassword,

                            "user_email":_userEmail
                          });

                          setState(() => _isLoading = false);
                          if (results['response'] == "1") {
                            _register();
                          } else {
                            Commons.showError(context, results["message"]);
                          }
                        } else {
                          Commons.showToast(context,
                              message:  AppLocalizations.of(context).translate('accept_rules_and_terms'),color: Colors.red);
                        }


                    }
                  },
                ),
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: _height * 0.02),
                    child: Text(
                      AppLocalizations.of(context).translate('has_account'),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    )),
                CustomButton(
                  btnLbl: AppLocalizations.of(context).translate('login'),
                  btnColor: Colors.white,
                  btnStyle: TextStyle(color: mainAppColor),
                  onPressedFunction: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _register() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return ConfirmationDialog(
            title:  AppLocalizations.of(context).translate('account_has created_successfully'),
            message:  AppLocalizations.of(context).translate('account_has created_successfully_use_app_now'),
          );
        });

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ActiveAccountScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    return PageContainer(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Image.asset("assets/images/back.png"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(AppLocalizations.of(context).translate('register')),
            centerTitle: true,
          ),
          body: Stack(
        children: <Widget>[

          Container(
            height: _height,
            color: mainAppColor,
            child: _buildBodyItem(),
          ),

          _isLoading
              ? Center(
                  child: SpinKitFadingCircle(color: mainAppColor),
                )
              : Container()
        ],
      )),
    );
  }
}
