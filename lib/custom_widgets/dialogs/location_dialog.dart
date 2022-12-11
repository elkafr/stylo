import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stylo/providers/location_state.dart';
import 'package:stylo/providers/home_provider.dart';
import 'package:stylo/custom_widgets/buttons/custom_button.dart';
import 'package:stylo/locale/app_localizations.dart';
import 'package:stylo/ui/add_ad/add_ad_screen.dart';
import 'package:stylo/utils/app_colors.dart';
import 'package:stylo/custom_widgets/safe_area/page_container.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stylo/utils/commons.dart';

class LocationDialog extends StatefulWidget {

  @override
  _LocationDialogState createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
    Completer<GoogleMapController> _mapController = Completer();
  Set<Marker> _markers = Set();
    LocationState _locationState;
    HomeProvider _homeProvider;
     Marker _marker;
    double _height = 0, _width = 0;


  @override
  Widget build(BuildContext context) {


  _locationState = Provider.of<LocationState>(context);
  _homeProvider = Provider.of<HomeProvider>(context);

  _height = MediaQuery.of(context).size.height;
  _width = MediaQuery.of(context).size.width;


  _marker = Marker(

         // optimized: false,
    zIndex: 5,
        onTap: () {
            print('Tapped');
          },
          draggable: true,
         onDragEnd: ((value) async {
           print('ismail');
            print(value.latitude);
            print(value.longitude);
            _locationState.setLocationLatitude(double.parse(_homeProvider.latValue));
            _locationState.setLocationlongitude(double.parse(_homeProvider.longValue));
  //              final coordinates = new Coordinates(
  //                _locationState.locationLatitude, _locationState
  //  .locationlongitude);
   List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
                 _locationState.locationLatitude, _locationState
   .locationlongitude);
  _locationState.setCurrentAddress(placemark[0].name);

      //   var addresses = await Geocoder.local.findAddressesFromCoordinates(
      //     coordinates);
      //   var first = addresses.first;
      // _locationState.setCurrentAddress(first.addressLine);
      // print(_locationState.address);
          }),
        markerId: MarkerId('my marker'),
        // infoWindow: InfoWindow(title: widget.address),
         position: LatLng(double.parse(_homeProvider.latValue),
         double.parse(_homeProvider.longValue)),
         flat: true
        );
   _markers.add( _marker);



    return  PageContainer(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Image.asset("assets/images/back.png"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(_homeProvider.currentLang=="ar"?"إختيار موقعك":"Select location",),
            centerTitle: true,
          ),
          body:  Container(
            height: _height,
            color: mainAppColor,
            child: LayoutBuilder(builder: (context,constraints){
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
                    child:  Column(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[


                        Container(

                          height: _height-200,
                          child:  GoogleMap(
                            markers: _markers,
                            mapType: MapType.normal,
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            // myLocationEnabled: true,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(double.parse(_homeProvider.latValue),
                                    double.parse(_homeProvider.longValue)),
                                zoom: 12),
                            onMapCreated: (GoogleMapController controller) async{

                              _locationState.setLocationLatitude(double.parse(_homeProvider.latValue));
                              _locationState.setLocationlongitude(double.parse(_homeProvider.longValue));

                              List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
                                  double.parse(_homeProvider.latValue),double.parse(_homeProvider.longValue));
                              _locationState.setCurrentAddress(placemark[0].name + '  ' + placemark[0].administrativeArea + ' '
                                  + placemark[0].country);

                              controller.setMapStyle(MapStyle.style);
                              _mapController.complete(controller);
                            },
                            onCameraMove: ((_position) => _updatePosition(_position)),
                          ),
                        ),

                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.only(
                                topLeft:  Radius.circular(20.00),
                                topRight:  Radius.circular(20.00),
                              ),
                              border: Border.all(color: accentColor)),

                          alignment: Alignment.center,
                          padding: EdgeInsets.all(12),

                         width: _width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset("assets/images/pin.png",color: Colors.white,),
                              Padding(padding: EdgeInsets.all(5)),
                              Text(_locationState.address!=null?_locationState.address:"",style: TextStyle(
                                  height: 1.5,
                                  color: Colors.white,fontSize: 18,fontWeight: FontWeight.w400
                              ))
                            ],
                          ),
                        ),
                        Container(


                            child: CustomButton(
                                height: 50,
                                btnLbl: _homeProvider.currentLang=="ar"?"اختيار الموقع الحالي":"Select current location",
                                onPressedFunction: () async {

    if(_locationState.locationLatitude==null || _locationState.locationlongitude==null){
    Commons.showError(context, _homeProvider.currentLang=="ar"?"عفوا يجب تحديد اللوكيشن":"Sorry, you must specify the location");
    }else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddAdScreen()));
    }

                                }))

                      ],
                    )),
              );
            }),
          )),
    );
  }

  Future<void> _updatePosition(CameraPosition _position) async {
    print(
        'inside updatePosition ${_position.target.latitude} ${_position.target.longitude}');
    // Marker marker = _markers.firstWhere(
    //     (p) => p.markerId == MarkerId('marker_2'),
    //     orElse: () => null);

     _markers.remove(_marker);
    _markers.add(
      Marker(
        markerId: MarkerId('marker_2'),
        position: LatLng(_position.target.latitude, _position.target.longitude),
        draggable: true,



      ),
    );
     print(_position.target.latitude);
            print(_position.target.longitude);
            _locationState.setLocationLatitude(_position.target.latitude);
            _locationState.setLocationlongitude(_position.target.longitude);
               List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
                 _locationState.locationLatitude, _locationState
   .locationlongitude);
  _locationState.setCurrentAddress(placemark[0].name + '  ' + placemark[0].administrativeArea + ' '
   + placemark[0].country);
  //              final coordinates = new Coordinates(
  //                _locationState.locationLatitude, _locationState
  //  .locationlongitude);
  //       var addresses = await Geocoder.local.findAddressesFromCoordinates(
  //         coordinates);
  //       var first = addresses.first;
  //     _locationState.setCurrentAddress(first.addressLine);
      print(_locationState.address);
      if (!mounted) return;
    setState(() {});
  }



}
















class MapStyle {
  static String style = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]
''';
}
