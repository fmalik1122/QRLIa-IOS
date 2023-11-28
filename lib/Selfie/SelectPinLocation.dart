import 'dart:async';

import 'package:barcodeprinter/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import '../DataModers/FrieList.dart';
import '../DataModers/FriendsProfile.dart';
import '../Friend Profile/Friends ProfileTab.dart';
import '../SDP.dart';
import '../api/api_client.dart';
import '../utils/controls.dart';
import 'TakeSelfie.dart';
import 'package:permission_handler/permission_handler.dart';


class SelectPinLocation extends StatefulWidget {


  const SelectPinLocation() : super();

  @override
  State<SelectPinLocation> createState() => _SelectPinLocationState();

}

class _SelectPinLocationState extends State<SelectPinLocation>  with WidgetsBindingObserver{
  bool _textFieldSelected = false;

  loc.Location location = loc.Location();
  loc.LocationData? locationData;
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  String comment = "";
  String address = "";
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746,);
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  List<Marker> _markers = <Marker>[];
  var isLight = true;
  FriendProfile data = FriendProfile();
  List<Friendslist> flist = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      loc.PermissionStatus permissionGranted;
      permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.granted){
        _acquireCurrentLocation();
      }else{
        return null;
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      appBar: AppBar(
        leading: null,
        backgroundColor: const Color(0xFFFFFFFF),
        centerTitle: true,
        title: Text(
            "Location of the meeting",
            style: TextDesigner(SDP.sdp(14), const Color(0xFFB492E8), 'b')
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus;
        },
        child: Container(
          height: _size.height,
          width: _size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Login/bg.png"), fit: BoxFit.cover)),
          padding: EdgeInsets.only(
              top: SDP.sdp(15), left: SDP.sdp(8), right: SDP.sdp(8)),
          child: Column(children: [
            Container(
              width: _size.width,
              height:  _size.height - SDP.sdp(300),
              child: Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    myLocationEnabled: true,
                    markers: Set<Marker>.of(_markers),
                    gestureRecognizers: {
                      Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      _acquireCurrentLocation();
                    },
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    if(Controls.usertype == "User"){
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                        return TakeSelfie();
                      }));
                    }else{
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {return FriendsProfile(fid: Controls.connectionfid, flist: flist, canBack: false,);}));
                    }
                  },
                  child: Container(
                    height: SDP.sdp(40),
                    width: SDP.sdp(100),
                    margin: EdgeInsets.only(top: SDP.sdp(10), bottom: SDP.sdp(20)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SDP.sdp(15)),
                      color: const Color(0xFFB492E8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: SDP.sdp(10),right: SDP.sdp(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Skip',
                            style: TextDesigner(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
                    if(locationData != null){
                      if(isConnected == true) {
                        Constants.Loading(context);
                        LatLng latLng = _markers.first.position;
                        List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
                        Placemark place = placemarks[0];
                        address = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}';
                        AddLoc(context, latLng.latitude.toString(), latLng.longitude.toString());
                      }
                      else {
                        Constants.ShowSnackBar(context, "Check your internet Connection!");
                      }
                    }else{
                      if(Controls.usertype == "User"){
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                          return TakeSelfie();
                        }));
                      }else{
                        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {return FriendsProfile(fid: Controls.connectionfid, flist: flist, canBack: false,);}));
                      }
                    }
                  },
                  child: Container(
                    height: SDP.sdp(40),
                    width: SDP.sdp(100),
                    margin: EdgeInsets.only(top: SDP.sdp(10), bottom: SDP.sdp(20), left: SDP.sdp(10)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SDP.sdp(15)),
                      color: const Color(0xFFB492E8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: SDP.sdp(10),right: SDP.sdp(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Done',
                            style: TextDesigner(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  void _acquireCurrentLocation() async {
    _markers.clear();
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        ShowLocationDiag(context);
        return null;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        ShowLocationDiag(context);
        return null;
      }
    }

    locationData = await location.getLocation();
    List<Placemark> placemarks = await placemarkFromCoordinates(locationData!.latitude!, locationData!.longitude!);
    Placemark place = placemarks[0];
    var addresses = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(locationData!.latitude!, locationData!.longitude!),
          tilt: 59.440717697143555,
          zoom: 19.151926040649414,
        )
    ));
    _markers.add(
        Marker(
            markerId: const MarkerId('BID'),
            draggable: true,
            position: LatLng(locationData!.latitude!, locationData!.longitude!),
            infoWindow: const InfoWindow(
                snippet: 'Long press to move marker',
                title: 'Meeting Location'
            ),
            onDragEnd: ((newPosition) async {
              List<Placemark> placemarks = await placemarkFromCoordinates(newPosition.latitude, newPosition.longitude);
              Placemark place = placemarks[0];
              var addresses = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
            }))
    );
    setState(() {});
  }

  AddLoc(BuildContext context, String lat, String long) {
    final client = ApiClient(
        Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
    client.AddLocationAPI("807620388065912", Controls.connectionid, address, long, lat).then((value) {
      Navigator.pop(context);
      Constants.ShowSnackBar(context, value.msg!);
     if (value.code == "1") {
       if(Controls.usertype == "User"){
         Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
           return TakeSelfie();
         }));
       }else{
         Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {return FriendsProfile(fid: Controls.connectionfid, flist: flist, canBack: false,);}));
       }
     }
    }, onError: (covariant) {
      Constants.ShowSnackBar(context, "Server Not Responding!");
    });
  }

  ShowLocationDiag(BuildContext context){
    return showMaterialModalBottomSheet(
        context: context,
        builder: (context) => Container(
          height: SDP.sdp(150),
          color: const Color(0xFFFFFFFF),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: SDP.sdp(10)),
                  child: Row(
                    children: [
                      Container(
                        width: SDP.sdp(260),
                        child: Text("Unable to find your location", style: TextDesigner_L(SDP.sdp(14), const Color(0xFF1A1C2D), 'r'))),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                          child: Text("X", style: TextDesigner_L(SDP.sdp(14), const Color(0xFF1A1C2D), 'r'))),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: SDP.sdp(10), bottom: SDP.sdp(10) ),
                    child: Text(
                        textAlign: TextAlign.center,
                        "Enable location to automatically pin\n your location of meeting", style: TextDesigner_L(SDP.sdp(12), const Color(0xFF1A1C2D), 'r'))),
                GestureDetector(
                  onTap: (){
                    openAppSettings();
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(240),
                    margin: EdgeInsets.only(top: SDP.sdp(10), bottom: SDP.sdp(10) ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SDP.sdp(8)),
                      color: const Color(0xFFB492E8),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SDP.sdp(10), right: SDP.sdp(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ENABLE LOCATION',
                            textAlign: TextAlign.center,
                            style: TextDesigner_L(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

}
