import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stylo/custom_widgets/buttons/custom_button.dart';
import 'package:stylo/custom_widgets/custom_text_form_field/custom_text_form_field.dart';
import 'package:stylo/custom_widgets/custom_text_form_field/validation_mixin.dart';
import 'package:stylo/custom_widgets/safe_area/page_container.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'package:stylo/networking/api_provider.dart';
import 'package:stylo/providers/auth_provider.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:stylo/utils/commons.dart';
import 'package:stylo/utils/urls.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class ContactWithUsScreen extends StatefulWidget {
  @override
  _ContactWithUsScreenState createState() => _ContactWithUsScreenState();
}

class _ContactWithUsScreenState extends State<ContactWithUsScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
   ApiProvider _apiProvider = ApiProvider();
 bool _isLoading = false;
bool _initialRun = true;
AuthProvider _authProvider;
 String _userName ='' ,_userEmail ='' , _message ='';

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
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Container(

                alignment: Alignment.center,

                child:  Image.asset('assets/images/logo.png',height:_height *0.2 ,color: mainAppColor,),
              ),
              Container(
                  margin: EdgeInsets.only(top: _height * 0.02),
                  child: CustomTextFormField(

                      prefixIconIsImage: true,
                      onChangedFunc: (text){
                        _userName = text;
                      },
                      prefixIconImagePath: 'assets/images/user.png',
                      hintTxt: AppLocalizations.of(context).translate('user_name'),
                      validationFunc: validateUserName

                  )),
              Container(
                margin: EdgeInsets.symmetric(vertical: _height * 0.02),
                child: CustomTextFormField(

                    prefixIconIsImage: true,
                    onChangedFunc: (text){
                      _userEmail = text;
                    },
                    prefixIconImagePath: 'assets/images/mail.png',
                    hintTxt: AppLocalizations.of(context).translate('email'),
                    validationFunc: validateUserEmail
                ),
              ),
              CustomTextFormField(
                maxLines: 3,
                onChangedFunc: (text){
                  _message = text;
                },
                hintTxt: AppLocalizations.of(context).translate('message'),
                validationFunc:  validateMsg,
              ),
              Container(
                  margin: EdgeInsets.only(top: _height *0.02,bottom: _height *0.02),
                  child: _buildSendBtn()
              ),



            ],
          ),
        ),
      ),
    );
  }

Widget _buildSendBtn() {
    return _isLoading
        ? Center(
            child:SpinKitFadingCircle(color: mainAppColor),
          )
        : CustomButton(
              btnLbl: AppLocalizations.of(context).translate('send'),
              onPressedFunction: () async {
                if (_formKey.currentState.validate()) {

                  setState(() {
                    _isLoading = true;
                  });
                 final results = await _apiProvider
                      .post(Urls.CONTACT_URL + "?api_lang=${_authProvider.currentLang}", body: {
                    "msg_name":  _userName,
                    "msg_email": _userEmail,
                    "msg_details":_message

                  });
               
            setState(() => _isLoading = false);
                  if (results['response'] == "1") {
                    Commons.showToast(context, message:results["message"]);
                    Navigator.pop(context);

                      
                  } else {
                    Commons.showError(context, results["message"]);

                  }
                   
                }
              },
            );
  }

 



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {
      _authProvider = Provider.of<AuthProvider>(context);

     _initialRun = false;
    }
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
            title:
            Text(AppLocalizations.of(context).translate('contact_us')),
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
