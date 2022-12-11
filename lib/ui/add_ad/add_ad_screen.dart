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


class AddAdScreen extends StatefulWidget {
  @override
  _AddAdScreenState createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> with ValidationMixin {
  double _height = 0, _width = 0;
  final _formKey = GlobalKey<FormState>();
  final format = DateFormat("yyyy-MM-dd");
  final format1 = DateFormat("HH:mm");

  String date2;
  String date3;

  Future<List<Country>> _countryList;
  Future<List<City>> _cityList;
  Future<List<CategoryModel>> _categoryList;
  Future<List<CategoryModel>> _subList;
  Country _selectedCountry;
  City _selectedCity;
  CategoryModel _selectedCategory;
  CategoryModel _selectedSub;
  bool _initialRun = true;
  HomeProvider _homeProvider;
  List<String> _genders ;
  File _imageFile;
  File _imageFile1;
  File _imageFile2;
  File _imageFile3;
  File _imageFile4;
  String _xx=null;
  Future<CommissionApp> _commissionApp;
  CommisssionAppProvider _commisssionAppProvider;
  bool checkedValue=false;
  bool checkedValue1=false;
  bool checkedValue2=false;
  bool checkedValue3=false;

  String _selectedMethod='';

  Future<List<Marka>> _markaList;
  Marka _selectedMarka;

  Future<List<Model>> _modelList;
  Model _selectedModel;

  String review;

  LocationState _locationState;

  dynamic _pickImageError;
  final _picker = ImagePicker();
  AuthProvider _authProvider;
  ApiProvider _apiProvider =ApiProvider();
  bool _isLoading = false;
  String _adsTitle = '';
  String _adsPrice = '';
  String _adsPhone = '';
  String _adsWhatsapp = '';
  String _adsDescription = '';
  String _adsOutColor='';
  String _adsFuel='';
  String _adsCylinders='';
  String _adsSpeedometer='';
  String _adsInColor='';
  String _adsChairsType='';
  NavigationProvider _navigationProvider;
  LocationData _locData;

  List<String> _adsPropulsion;
  String _selectedAdsPropulsion;

  List<String> _adsOpenRoof;
  String _selectedAdsOpenRoof;

  List<String> _adsGps;
  String _selectedAdsGps;

  List<String> _adsBluetooth;
  String _selectedAdsBluetooth;

  List<String> _adsCd;
  String _selectedAdsCd;

  List<String> _adsDvd;
  String _selectedAdsDvd;

  List<String> _adsSensors;
  String _selectedAdsSensors;

  List<String> _adsGuarantee;
  String _selectedAdsGuarantee;

  List<String> _adsCamera;
  String _selectedAdsCamera;

  List<String> _adsGear;
  String _selectedAdsGear;

   Future<void> _getCurrentUserLocation() async {
     _locData = await Location().getLocation();
    if(_locData != null){
      print('lat' + _locData.latitude.toString());
      print('longitude' + _locData.longitude.toString());
      Commons.showToast(context, message:
        AppLocalizations.of(context).translate('detect_location'));
        setState(() {

        });
    }
  }



  Widget _buildRow(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
          ),
          Container(
            width:  _width *0.55,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,fontSize: 12, fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }


  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }


  void _onImageButtonPressed1(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile1 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }


  void _onImageButtonPressed2(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile2 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }


  void _onImageButtonPressed3(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile3 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }


  void _onImageButtonPressed4(ImageSource source, {BuildContext context}) async {
    try {
      final pickedFile = await _picker.getImage(source: source);
      _imageFile4 = File(pickedFile.path);
      setState(() {});
    } catch (e) {
      _pickImageError = e;
    }
  }




  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialRun) {

      _adsPropulsion = ["دفع امامي",
        "دفع خلفي"];

      _adsOpenRoof = ["نعم", "لا"];
      _adsGps = ["نعم", "لا"];
      _adsBluetooth = ["نعم", "لا"];
      _adsCd = ["نعم", "لا"];
      _adsDvd = ["نعم", "لا"];
      _adsSensors = ["نعم", "لا"];
      _adsGuarantee = ["نعم", "لا"];
      _adsCamera = ["نعم", "لا"];
      _adsGear = ["يدوي", "اتوماتك"];


      _homeProvider = Provider.of<HomeProvider>(context);
      _categoryList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:false ,catId: '0',catName:
      AppLocalizations.of(context).translate('total'),catImage: 'assets/images/all.png'),enableSub: false);
      _commisssionAppProvider = Provider.of<CommisssionAppProvider>(context);
      _commissionApp = _commisssionAppProvider.getCommissionApp();
      _subList = _homeProvider.getCategoryList(categoryModel:  CategoryModel(isSelected:false ,catId: '0',catName:
      AppLocalizations.of(context).translate('all'),catImage: 'assets/images/all.png'),enableSub: true,catId:'6');

      _countryList = _homeProvider.getCountryList();
      _cityList = _homeProvider.getCityList(enableCountry: true,countryId:'500');
      _markaList = _homeProvider.getMarkaList();
      _modelList = _homeProvider.getModelList();


      _initialRun = false;
    }
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

      child: SingleChildScrollView(
        child: Form(
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
                child: Text(_homeProvider.currentLang=='ar'?"وقت الحجز":"Booking time",style: TextStyle(color: accentColor,fontWeight: FontWeight.bold,fontSize: 21),),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: _height * 0.04),
                child: Text(_homeProvider.currentLang=='ar'?"حدد الوقت المناسب لطلب الخياط عندك":"Select the right time to order your tailor",style: TextStyle(color: hintColor,fontSize: 16),),
              ),


              SizedBox(
                height: 30,
              ),



              Container(
                margin: EdgeInsets.symmetric(horizontal: _height * 0.04),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  border: Border.all(
                    color: hintColor.withOpacity(0.4),
                  ),
                  color: Colors.white,
                ),
                child: DateTimeField(

                  format: format,

                  decoration: InputDecoration(

                      border: InputBorder.none,
                      suffixIcon: Image.asset("assets/images/date.png"),
                      hintText: _homeProvider.currentLang=="ar"?"حدد التاريخ":"Select date",
                      hintStyle: TextStyle(color: mainAppColor,fontSize: 16),
                      contentPadding: EdgeInsets.all(10)
                  ),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(

                        context: context,
                        firstDate: new DateTime.now(),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100));
                  },
                  onChanged: (dt) {
                    setState(() => date2 = dt.toString());
                    print('$date2');
                  },
                ),
              ),


              SizedBox(height: 15,),


              Container(
                margin: EdgeInsets.symmetric(horizontal: _height * 0.04),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  border: Border.all(
                    color: hintColor.withOpacity(0.4),
                  ),
                  color: Colors.white,
                ),
                child: DateTimeField(
                  format: format1,
                  decoration: InputDecoration(

                      border: InputBorder.none,
                      suffixIcon: Image.asset("assets/images/time.png"),
                      hintText: _homeProvider.currentLang=="ar"?"حدد الوقت":"Select time",
                      hintStyle: TextStyle(color: mainAppColor,fontSize: 16),
                      contentPadding: EdgeInsets.all(10)
                  ),
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),

                      builder: (BuildContext context, Widget child) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false,),
                          child: child,
                        );
                      },
                    );
                    return DateTimeField.convert(time);
                  },
                  onChanged: (dt) {
                    var x=dt.toString()[11];
                    var y=dt.toString()[12];

                    if(int.parse(x+y)<14 || int.parse(x+y)>22){
                      setState(() {
                        date3="";
                      });
                      Commons.showError(context, "عفوا ساعات العمل لدينا من 2 بعد الظهر الى 10 مساءا , يجب اختيار الساعة ضمن هذا الوقت");
                    }else{
                      setState(() => date3 = dt.toString());
                      print('$date3');
                    }


                  },
                ),
              ),




              SizedBox(
                height: 30,
              ),



              Container(
                margin: EdgeInsets.symmetric(horizontal: _height * 0.04),
                child: Row(
                  children: <Widget>[
                    Text(_homeProvider.currentLang=='ar'?"دفع الخدمة":"service payment",style: TextStyle(color: accentColor,fontWeight: FontWeight.bold,fontSize: 21),),

                   Padding(padding: EdgeInsets.all(5)),

                    FutureBuilder<String>(
                        future: Provider.of<HomeProvider>(context,
                            listen: false)
                            .getOmar() ,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Center(
                                child: SpinKitFadingCircle(color: Colors.black),
                              );
                            case ConnectionState.active:
                              return Text('');
                            case ConnectionState.waiting:
                              return Center(
                                child: SpinKitFadingCircle(color: Colors.black),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return Text("Error");
                              } else {


                                return  Text("("+snapshot.data+")"+" ريال ",style: TextStyle(color: accentColor,fontWeight: FontWeight.bold,fontSize: 21),);
                              }
                          }
                          return Center(
                            child: SpinKitFadingCircle(color: mainAppColor),
                          );
                        })
                    
                    
                  ],
                ),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: _height * 0.04),
                child: Text(_homeProvider.currentLang=='ar'?"قم بدفع الخدمة الان لاكمال الطلب":"Pay the service now to complete the order",style: TextStyle(color: hintColor,fontSize: 16),),
              ),



              SizedBox(
                height: 30,
              ),


              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: _height * 0.02),
                child: CheckboxListTile(
                  checkColor: Colors.white,
                  activeColor: accentColor,
                  title: Row(
                    children: <Widget>[
                      Image.asset("assets/images/cash.png"),
                      Padding(padding: EdgeInsets.all(5)),
                      Text(_homeProvider.currentLang=="ar"?"كاش":"Cash",style: TextStyle(fontSize: 15),)
                    ],
                  ),
                  value: checkedValue,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValue = newValue;
                      _homeProvider.setCheckedValue(newValue.toString());
                      print(_homeProvider.checkedValue);

                        checkedValue1=false;
                        checkedValue2=false;
                        checkedValue3=false;

                      _selectedMethod="1";
                    });
                  },

                ),
              ),



              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: _height * 0.02),
                child: CheckboxListTile(
                  checkColor: Colors.white,
                  activeColor: accentColor,
                  title: Row(
                    children: <Widget>[
                      Image.asset("assets/images/visa.png"),
                      Padding(padding: EdgeInsets.all(5)),
                      Text(_homeProvider.currentLang=="ar"?"فيزا كارد":"Visa Card",style: TextStyle(fontSize: 15),)
                    ],
                  ),
                  value: checkedValue1,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValue1 = newValue;
                      _homeProvider.setCheckedValue1(newValue.toString());
                      print(_homeProvider.checkedValue1);

                      checkedValue=false;
                      checkedValue2=false;
                      checkedValue3=false;

                      _selectedMethod="2";

                    });
                  },

                ),
              ),




              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: _height * 0.02),
                child: CheckboxListTile(
                  checkColor: Colors.white,
                  activeColor: accentColor,
                  title: Row(
                    children: <Widget>[
                      Image.asset("assets/images/master.png"),
                      Padding(padding: EdgeInsets.all(5)),
                      Text(_homeProvider.currentLang=="ar"?"ماستر كارد":"Master Card",style: TextStyle(fontSize: 15),)
                    ],
                  ),
                  value: checkedValue2,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValue2 = newValue;
                      _homeProvider.setCheckedValue2(newValue.toString());
                      print(_homeProvider.checkedValue2);

                      checkedValue1=false;
                      checkedValue=false;
                      checkedValue3=false;

                      _selectedMethod="3";

                    });
                  },

                ),
              ),


              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: _height * 0.02),
                child: CheckboxListTile(
                  checkColor: Colors.white,
                  activeColor: accentColor,
                  title: Row(
                    children: <Widget>[
                      Image.asset("assets/images/mada.png"),
                      Padding(padding: EdgeInsets.all(5)),
                      Text(_homeProvider.currentLang=="ar"?"مدي":"Mada",style: TextStyle(fontSize: 15),)
                    ],
                  ),
                  value: checkedValue3,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValue3= newValue;
                      _homeProvider.setCheckedValue3(newValue.toString());
                      print(_homeProvider.checkedValue3);

                      checkedValue1=false;
                      checkedValue2=false;
                      checkedValue=false;


                      _selectedMethod="4";

                    });
                  },

                ),
              ),



              SizedBox(
                height: 30,
              ),


              CustomButton(
                btnLbl: AppLocalizations.of(context).translate('publish_ad'),
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


                 if(_selectedMethod==""){
                   Commons.showError(context, _homeProvider.currentLang=="ar"?"يجب اختيار طريقة الدفع":"Payment method must be selected");
                 }else{


                    if(_selectedMethod=="2" || _selectedMethod=="3" || _selectedMethod=="4"){
                      Commons.showError(context, _homeProvider.currentLang=="ar"?"عفوا طريقة الدفع هذه غير متوفرة حاليا":"Sorry, this payment method is not currently available");
                    }else{


                      if(_locationState.locationLatitude==null || _locationState.locationlongitude==null){
                        Commons.showError(context, _homeProvider.currentLang=="ar"?"عفوا يجب تحديد اللوكيشن":"Sorry, you must specify the location");
                      }else {



                       if(date3==""){


                         Commons.showError(context, _homeProvider.currentLang=="ar"?"عفوا يجب تحديد وقت متاح للحجز":"Sorry, you must specify an available time for reservations");

    }else{
                         FocusScope.of(context).requestFocus(FocusNode());
                         setState(() => _isLoading = true);

                         FormData formData = new FormData.fromMap({
                           "user_id": _authProvider.currentUser.userId,
                           "ads_type": _selectedMethod,
                           "ads_bookDate": date2,
                           "ads_bookTime": date3,
                           "ads_mapx": _locationState.locationLatitude
                               .toString() != null ? _locationState
                               .locationLatitude.toString() : _homeProvider
                               .latValue,
                           "ads_mapy": _locationState.locationlongitude
                               .toString() != null ? _locationState
                               .locationlongitude.toString() : _homeProvider
                               .longValue,
                         });
                         final results = await _apiProvider
                             .postWithDio(Urls.ADD_AD_URL +
                             "?api_lang=${_authProvider.currentLang}",
                             body: formData);
                         setState(() => _isLoading = false);


                         if (results['response'] == "1") {
                           showDialog(
                               context: context,
                               barrierDismissible: true,
                               builder: (_) {
                                 return ConfirmationDialog(
                                   title: AppLocalizations.of(context).translate(
                                       'ad_has_published_successfully'),
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
                       }

                      }



                           }




                  }}}
                },
              ),
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
    _authProvider = Provider.of<AuthProvider>(context);
    _navigationProvider = Provider.of<NavigationProvider>(context);
    _locationState = Provider.of<LocationState>(context);
    return PageContainer(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Image.asset("assets/images/back.png"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(_homeProvider.currentLang=="ar"?"دفع الخدمة":"service payment",),
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
