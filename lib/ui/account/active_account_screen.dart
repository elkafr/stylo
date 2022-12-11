import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stylo/custom_widgets/buttons/custom_button.dart';
import 'package:stylo/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:stylo/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:stylo/custom_widgets/safe_area/page_container.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'package:stylo/networking/api_provider.dart';
import 'package:stylo/providers/auth_provider.dart';
import 'package:stylo/providers/home_provider.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:stylo/utils/commons.dart';
import 'package:stylo/utils/urls.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class ActiveAccountScreen extends StatefulWidget {
  @override
  _ActiveAccountScreenState createState() => _ActiveAccountScreenState();
}

class _ActiveAccountScreenState extends State<ActiveAccountScreen>
    with ValidationMixin {
  double _height = 0, _width = 0;
  bool _isLoading = false;
  String _activationCode = '';
  ApiProvider _apiProvider = ApiProvider();
  AuthProvider _authProvider;
  HomeProvider _homeProvider;
  final _formKey = GlobalKey<FormState>();

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: _height * 0.05),
                child: Image.asset(
                  'assets/images/logo.png',color: mainAppColor,
                  height: _height * 0.2,
                ),
              ),
              Text(
                _homeProvider.currentLang=="ar"?"كود تفعيل الحساب":"Active Account COde",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.only(bottom: _height * 0.02),
                child: Text(

                  _homeProvider.currentLang=="ar"?"ادخل الكود المرسل على ايميلك لتفعيل الحساب":"Enter the code sent on your email to activate the account",
                  style: TextStyle(color: Color(0xffC5C5C5), fontSize: 14),
                ),
              ),
              CustomTextFormField(
                prefixIconIsImage: true,
                prefixIconImagePath: 'assets/images/edit.png',
                hintTxt:  AppLocalizations.of(context).translate('code_here'),
                onChangedFunc: (text) {
                  _activationCode = text;
                },
                validationFunc: validateActivationCode,
              ),
              SizedBox(
                height: _height * 0.01,
              ),
              _buildRecoveryBtn(),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecoveryBtn() {
    return  CustomButton(
            btnLbl: _homeProvider.currentLang=="ar"?"تفعيل":"Active",
            onPressedFunction: () async {
              if (_formKey.currentState.validate()) {
                setState(() {
                  _isLoading = true;
                });
                final results =
                    await _apiProvider.post("https://works.rawa8.com/apps/stylo/api/activate?api_lang=${_authProvider.currentLang}", body: {
                  "activation_code": _activationCode,
                });

                setState(() => _isLoading = false);
                if (results['response'] == "1") {
                  _authProvider.setActivationCode(_activationCode);
                  Commons.showToast(context, message: results["message"],color: mainAppColor);
                  Navigator.pushNamed(context, '/login_screen');
                } else {
                  Commons.showError(context, results["message"]);
                }
              }
            },
          );
  }



  @override
  Widget build(BuildContext context) {
    _height =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    _width = MediaQuery.of(context).size.width;
    _authProvider = Provider.of<AuthProvider>(context);
    _homeProvider = Provider.of<HomeProvider>(context);
    return PageContainer(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Image.asset("assets/images/back.png"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title:
            Text(_homeProvider.currentLang=="ar"?"تفعيل الحساب":"Active account",),
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
        :Container()
        ],
      )),
    );
  }
}
