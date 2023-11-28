import 'dart:async';
import 'dart:io';
import 'package:barcodeprinter/Selfie/TakeSelfie.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../DataModers/FrieList.dart';
import '../DataModers/FriendsProfile.dart';
import '../DataModers/NetworkListModel.dart';
import '../SDP.dart';
import '../api/api_client.dart';
import '../bottam navigation/BottomNavigation.dart';
import '../utils/constants.dart';
import '../utils/controls.dart';

class FriendsProfile extends StatefulWidget {

  String fid;
  List<Friendslist> flist = [];
  bool canBack = false;

  FriendsProfile({required this.fid, required this.flist, required this.canBack}) : super();

  @override
  State<FriendsProfile> createState() => _FriendsProfileState(fid, flist, canBack);
}

class _FriendsProfileState extends State<FriendsProfile> {

  List<Friendslist> flist = [];
  bool _canBack = false;

  _FriendsProfileState(String id,List<Friendslist> _flist, bool canback) {
    _fid = id;
    flist = _flist;
    _canBack = canback;
  }

  String? _fid;
  static FriendProfile friends = FriendProfile();
  bool _textFieldSelected = false;
  bool _editable = false;
  final Image _img = const Image(image: AssetImage('assets/profile/profile_image.png'),);
  bool isSelected = false;
  String linkName = 'Zomato';
  final List<String> _link = ['Zomato', 'Food Panda'];
  final ImagePicker _picker = ImagePicker();
  File? image;
  Size? _size;
  List<NetworkslistModel> usernetworklist = [];
  List<TextEditingController> _controllers = [];
  List<TextEditingController> _titleControllers = [];
  List<GlobalKey<FormState>> _formKey = [];
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<FormState> usernameformkey = GlobalKey<FormState>();
  String pattern = r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)';
  String? pass = " ", cpass, imagename;
  String title = "Title", url = "Url";
  bool erro =  false;
  bool virtualBusiness = false;
  String isvirtual = "0";
  String message = "";
  String selfie = "";
  String lat = "";
  String long = "";
  bool _profileshare = false;
  String hnt = "Enter Url", accounttype = "User", userimage = "", handle = "", longitude = "", latitude = "", blongitude = "", blatitude = "";
  TextEditingController username = TextEditingController(), website = TextEditingController() , email = TextEditingController(),
   userphone = TextEditingController(), baddress = TextEditingController(), cusaddress = TextEditingController(), empname = TextEditingController(),
   worktitle = TextEditingController(), workemail = TextEditingController(), btype = TextEditingController(), about = TextEditingController() , meetingloc = TextEditingController() , meetingtime = TextEditingController(), comments = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746,);
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  List<Marker> _markers = <Marker>[];


  @override
  void initState() {
    super.initState();
    _getFriendProfile(context);
    _getUserNetworkList(context);
  }

  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    _size = MediaQuery.of(context).size;
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        iconTheme: const IconThemeData(color: Colors.black, //change your color here
        ),
        centerTitle: true,
        title: Text("Friend's Profile", style: TextDesigner(SDP.sdp(16), const Color(0xFFB492E8), 'b')),
        leading: GestureDetector(
          onTap: (){
            if(_canBack){
              Navigator.pop(context);
            }else{
              Controls.bottomIndex = 1;
              Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => BottomNavigation(),
                ), (route) =>
              false, //if you want to disable back feature set to false
              );
            }
          },
          child: const Icon(
            Icons.arrow_back,
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              if (friends.blockstatus.toString() == "0") {
                _blockUser(context);
              } else {
                _unblockUser(context);
              }
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: SDP.sdp(8)),
              child: Text(friends.blockstatus.toString() == "0" ? "Block" : "Unblock",
                  style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r')),
            ),
          ),
        ],
      ),
      body: Container(
        height: _size!.height,
        width: _size!.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Login/bg.png"), fit: BoxFit.cover)),
        padding: EdgeInsets.only(
            top: SDP.sdp(10), left: SDP.sdp(10), right: SDP.sdp(10)),
        child: SingleChildScrollView(
          child: Column(children: [
            Column(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await showDialog(
                                context: context,
                                builder: (_) => ImageDialog(link : selfie == "" ? "http://qrlia.com/core/public/appusers/qrliaface-icon.png" : selfie)
                            );
                          },
                          child: Container(
                            height: SDP.sdp(60),
                            width: SDP.sdp(60),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: selfie == ""
                                      ? const CachedNetworkImageProvider(
                                      "http://qrlia.com/core/public/appusers/qrliaface-icon.png")
                                      : CachedNetworkImageProvider(selfie),
                                ),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(SDP.sdp(50))),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await showDialog(
                                context: context,
                                builder: (_) => ImageDialog(link : userimage == "" ? "http://qrlia.com/core/public/appusers/qrliaface-icon.png" : userimage)
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(left : SDP.sdp(20)),
                            height: SDP.sdp(60),
                            width: SDP.sdp(60),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: userimage == ""
                                      ? NetworkImage("http://qrlia.com/core/public/appusers/qrliaface-icon.png")
                                      : NetworkImage(userimage),
                                ),
                                shape: BoxShape.circle),
                          ),
                        ),
                        Positioned(
                            bottom: SDP.sdp(0),
                            left: SDP.sdp(0),
                            child: GestureDetector(
                              onTap: () async {
                                Controls.connectionid = friends.connectionid.toString();
                                Controls.connectionfid = _fid.toString();
                                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                                  return TakeSelfie();
                                }));
                              },
                              child: CircleAvatar(
                                backgroundColor: const Color(0xFFB492E8),
                                radius: SDP.sdp(10),
                                child: Icon(
                                  Icons.edit,
                                  size: SDP.sdp(10),
                                  color: const Color(0xFFFFFFFF),
                                ),
                              ),
                            ))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: SDP.sdp(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: SDP.sdp(2)),
                            alignment: Alignment.center,
                            child: Text(
                              username.text + "@" +  handle,
                              style: TextDesigner(
                                  SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                            ),
                          ),
                          Container(child: Text(
                              email.text,
                              style: TextDesigner(
                                  SDP.sdp(10), const Color(0xFFA9A9A9), 'r'),
                            ),),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top :SDP.sdp(10)),
              alignment: Alignment.topLeft,
              child: Text(
                'Friends Name',
                style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
              ),
            ),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(25),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Container(
                height: SDP.sdp(30),
                width: SDP.sdp(100),
                alignment: Alignment.centerLeft,
                child: Form(
                  key: usernameformkey,
                  child: TextFormField(
                    controller: username,
                    style : TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                    textCapitalization: TextCapitalization.sentences,
                    enabled: _editable ? true : false,
                    validator: (value) {
                      if(value!.isEmpty){
                        return "Name field cannot be empty";
                      }else{

                        return null;
                      }
                    },
                    onChanged: (v) {
                      usernameformkey.currentState!.validate();
                    },
                    decoration: InputDecoration(
                      isDense: Platform.isIOS ? true : false,
                      isCollapsed: Platform.isIOS ? true : false,
                      contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.zero,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      filled: false,
                      fillColor: const Color(0xFFF2F2F2),
                      hintText: "Full Name",
                      hintStyle: TextDesigner(
                          SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top :SDP.sdp(10)),
              alignment: Alignment.topLeft,
              child: Text(
                'Phone Number',
                style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
              ),
            ),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(25),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Container(
                height: SDP.sdp(30),
                width: SDP.sdp(100),
                alignment: Alignment.centerLeft,
                child: TextFormField(
                  controller: userphone,
                  style : TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                  textCapitalization: TextCapitalization.sentences,
                  enabled: _editable ? true : false,
                  validator: (value) {
                    if(value!.isEmpty){
                      return "Name field cannot be empty";
                    }else{

                      return null;
                    }
                  },
                  onChanged: (v) {
                    usernameformkey.currentState!.validate();
                  },
                  decoration: InputDecoration(
                    isDense: Platform.isIOS ? true : false,
                    isCollapsed: Platform.isIOS ? true : false,
                    contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.zero,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    filled: false,
                    fillColor: const Color(0xFFF2F2F2),
                    hintText: "Phone Number",
                    hintStyle: TextDesigner(
                        SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top :SDP.sdp(10)),
              alignment: Alignment.topLeft,
              child: Text(
                'Employer or Business',
                style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
              ),
            ),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(25),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: empname,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        isDense: Platform.isIOS ? true : false,
                        isCollapsed: Platform.isIOS ? true : false,
                        contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.zero,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        fillColor: const Color(0xFFF2F2F2),
                        hintText: "Employer or business or school name",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top :SDP.sdp(10)),
              alignment: Alignment.topLeft,
              child: Text(
                'Work Title',
                style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
              ),
            ),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(25),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: worktitle,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        isDense: Platform.isIOS ? true : false,
                        isCollapsed: Platform.isIOS ? true : false,
                        contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.zero,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        fillColor: const Color(0xFFF2F2F2),
                        hintText: "Title at work",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top :SDP.sdp(10)),
              alignment: Alignment.topLeft,
              child: Text(
                'Professional Email',
                style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
              ),
            ),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(25),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: workemail,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        isDense: Platform.isIOS ? true : false,
                        isCollapsed: Platform.isIOS ? true : false,
                        contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.zero,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        fillColor: const Color(0xFFF2F2F2),
                        hintText: "Work or school or other email",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top :SDP.sdp(10)),
              alignment: Alignment.topLeft,
              child: Text(
                'About',
                style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
              ),
            ),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(25),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: about,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        isDense: Platform.isIOS ? true : false,
                        isCollapsed: Platform.isIOS ? true : false,
                        contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.zero,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        fillColor: const Color(0xFFF2F2F2),
                        hintText: "About",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            btype.text != "" ? Container(
              margin: EdgeInsets.only(top :SDP.sdp(10)),
              alignment: Alignment.topLeft,
              child: Text(
                'Business Type',
                style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
              ),
            ) : Container(),
            btype.text != "" ? Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(25),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: btype,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        isDense: Platform.isIOS ? true : false,
                        isCollapsed: Platform.isIOS ? true : false,
                        contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.zero,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        fillColor: const Color(0xFFF2F2F2),
                        hintText: "Work / school / other email",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ) : Container(),
            website.text != "" ? Container(
              margin: EdgeInsets.only(top :SDP.sdp(10)),
              alignment: Alignment.topLeft,
              child: Text(
                'Website',
                style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
              ),
            ) : Container(),
            website.text != "" ? Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(25),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: website,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        isDense: Platform.isIOS ? true : false,
                        isCollapsed: Platform.isIOS ? true : false,
                        contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.zero,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        fillColor: const Color(0xFFF2F2F2),
                        hintText: "Work / school / other email",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ) : Container(),
            baddress.text != "" ? Container(
              margin: EdgeInsets.only(top :SDP.sdp(10)),
              alignment: Alignment.topLeft,
              child: Text(
                'Business Address',
                style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
              ),
            ) : Container(),
            baddress.text != "" ? Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(25),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: baddress,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        isDense: Platform.isIOS ? true : false,
                        isCollapsed: Platform.isIOS ? true : false,
                        contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.zero,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        fillColor: const Color(0xFFF2F2F2),
                        hintText: "Work or school or other email",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ) : Container(),
            cusaddress.text != "" ? Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(25),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: cusaddress,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        isDense: Platform.isIOS ? true : false,
                        isCollapsed: Platform.isIOS ? true : false,
                        contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.zero,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        fillColor: const Color(0xFFF2F2F2),
                        hintText: "Work or school or other email",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ) : Container(),
            Container(
              margin: EdgeInsets.only(top: SDP.sdp(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      var uri = 'sms:' + friends.friendphone! + '?body= ';
                      await launch(uri);
                    },
                    child: Container(
                      child: Image(
                        image:
                        Svg("assets/Profile/Message.svg"),
                        height: SDP.sdp(25),
                        width: SDP.sdp(25),
                      ),   ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      var uri = 'tel:' + friends.friendphone!;
                      if (Platform.isAndroid) {
                        uri = 'tel:' + friends.friendphone!;
                        await launch(uri);
                      } else if (Platform.isIOS) {
                        // iOS
                        uri ='tel:' + friends.friendphone!;
                        await launch(uri);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: SDP.sdp(5), right: SDP.sdp(5)),
                      child: Image(
                        image:
                        Svg("assets/Profile/Call.svg"),
                        height: SDP.sdp(25),
                        width: SDP.sdp(25),
                      ), ),
                  ),
                ],
              ),
            ),
            usernetworklist.isNotEmpty ? Container(
              margin:EdgeInsets.only(top :SDP.sdp(10), bottom: SDP.sdp(10)) ,
              alignment: Alignment.center,
              child: Text(
                'Social Links',
                style: TextDesigner(SDP.sdp(14),const Color(0xFF000000),'r'),
              ),
            ) : Container(),
            SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: usernetworklist.length,
                itemBuilder: (BuildContext context, index) {
                  return GestureDetector(
                    onTap: () async {
                      if(usernetworklist[index].networktype == "custom"){
                        if(usernetworklist[index].networkvalue!.toLowerCase().startsWith("https")){
                          var url = usernetworklist[index].networkvalue.toString();
                          await launch(url);
                        }else if(usernetworklist[index].networkvalue!.toLowerCase().startsWith("http")){
                          var url = usernetworklist[index].networkvalue.toString().replaceAll("Http" , "Https:");
                          await launch(url);
                        }else{
                          var url = "https://" + usernetworklist[index].networkvalue.toString();
                          await launch(url);
                        }
                      }else{
                        if(usernetworklist[index].networkformat == "url"){
                          if(usernetworklist[index].networkvalue!.toLowerCase().startsWith("https")){
                            var url = usernetworklist[index].networkvalue.toString();
                            await launch(url);
                          }else if(usernetworklist[index].networkvalue!.toLowerCase().startsWith("http")){
                            var url = usernetworklist[index].networkvalue.toString().replaceAll("Http" , "Https:");
                            await launch(url);
                          }
                          else{
                            var url = "https://" + usernetworklist[index].networkvalue.toString();
                            await launch(url);
                          }
                        }else{
                          var url = usernetworklist[index].networkurlforhandles.toString() + usernetworklist[index].networkvalue.toString();
                          await launch(url);
                        }
                      }
                    },
                    child: Container(
                      height: SDP.sdp(40),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: SDP.sdp(2)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: SDP.sdp(15),
                              backgroundImage:
                              usernetworklist[index].networkicon == ""
                                  ? NetworkImage(
                                  'https://via.placeholder.com/150')
                                  : NetworkImage(
                                  usernetworklist[index].networkicon!),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: SDP.sdp(10)),
                                  child: SizedBox(
                                    width: SDP.sdp(135),
                                    child: Text(
                                      usernetworklist[index].networkname == ""
                                          ? "QRLia"
                                          : usernetworklist[index].networkname!,
                                      style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: SDP.sdp(10)),
                                  child: SizedBox(
                                    width: SDP.sdp(135),
                                    child: Text(
                                      usernetworklist[index].networkname == ""
                                          ? "QrLia"
                                          : usernetworklist[index].networkvalue!,
                                      style: TextDesigner(SDP.sdp(10), const Color(0xFFAAACAE), 'r'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            meetingloc.text == "" ? Container() : Container(
                margin: EdgeInsets.only(top: SDP.sdp(5), bottom: SDP.sdp(5)),
                height: SDP.sdp(400),
                width: SDP.sdp(200),
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(SDP.sdp(20))),
                child: GoogleMap(
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
                )),
            Container(
              margin: EdgeInsets.only(top :SDP.sdp(10)),
              alignment: Alignment.topLeft,
              child: Text(
                'Meeting Location',
                style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
              ),
            ),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(25),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: meetingloc,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        isDense: Platform.isIOS ? true : false,
                        isCollapsed: Platform.isIOS ? true : false,
                        contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.zero,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        fillColor: const Color(0xFFF2F2F2),
                        hintText: "Meeting Location",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top :SDP.sdp(10)),
              alignment: Alignment.topLeft,
              child: Text(
                'Meeting Time',
                style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
              ),
            ),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(25),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: meetingtime,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        isDense: Platform.isIOS ? true : false,
                        isCollapsed: Platform.isIOS ? true : false,
                        contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.zero,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        fillColor: const Color(0xFFF2F2F2),
                        hintText: "Meeting Time",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top :SDP.sdp(10)),
              alignment: Alignment.topLeft,
              child: Text(
                'Comments',
                style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
              ),
            ),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(25),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: comments,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        isDense: Platform.isIOS ? true : false,
                        isCollapsed: Platform.isIOS ? true : false,
                        contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.zero,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        fillColor: const Color(0xFFF2F2F2),
                        hintText: "Comments",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
      floatingActionButton: _profileshare ? FloatingActionButton(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => CountryDialog(context));
        },
        child: Icon(
          Icons.share_rounded
        ),
        backgroundColor: Color(0xFFEEEEEE),
        tooltip: 'Capture Picture',
        elevation: 5,
        splashColor: Colors.grey,
      )
          : Container(),
    );
  }

  Future<void> _getFriendProfile(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(
          Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.GetFriendProfileAPI("807620388065912", Controls.id, _fid!).then((value) async {
            friends = value;
            if (friends.code == "1") {
              Navigator.of(context).pop();
              username.text = friends.friendname!;
              userphone.text = friends.friendcountrycode! + friends.friendphone!;
              selfie = friends.meetingselfie!;
              handle = friends.friendusername!;
              userimage = friends.friendimage!;
              empname.text = friends.workbusinessname!;
              website.text = friends.website!;
              worktitle.text = friends.worktitle!;
              workemail.text = friends.workemail!;
              email.text = friends.friendemail!;
              btype.text = friends.friendbusinesstype!;
              about.text = friends.about!;
              comments.text = friends.meetingcomment!;
              meetingtime.text = friends.meetingdatetime.toString();
              meetingloc.text = friends.meetingaddress.toString();
              lat = friends.meetinglongitude.toString();
              long = friends.meetinglatitude.toString();
              baddress.text = friends.businessaddress.toString();
              cusaddress.text = friends.cusaddress.toString();
              blongitude = friends.businesslongitude.toString();
              blatitude = friends.businesslatitude.toString();

              if (friends.allowprofilesharing.toString() == "0") {
                _profileshare = false;
              } else {
                _profileshare = true;
              }

              if(meetingloc.text != ""){
                // From coordinates
                List<Placemark> placemarks = await placemarkFromCoordinates(double.tryParse(lat)!, double.tryParse(long)!);
                Placemark place = placemarks[0];
                meetingloc.text = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
              }

              if (blatitude != "") {
                List<Placemark> placemarks = await placemarkFromCoordinates(double.tryParse(blatitude)!, double.tryParse(blongitude)!);
                Placemark place = placemarks[0];
                baddress.text = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
              }

              setState(() {});

            } else {
              Navigator.of(context).pop();
              Constants.PopupDialog(context, value.msg!);
            }
          }, onError: (covariant) {
        Navigator.of(context).pop();
        Constants.PopupDialog(context, "Server Not Responding!" + covariant.toString());
      });
    } else {
      Constants.PopupDialog(context, "Check your internet Connection!");
    }
  }

  Future<void> _getUserNetworkList(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      final client = ApiClient(
          Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.UserNetworkList("807620388065912", _fid!).then((value) {
        if (value.code == "1") {
          usernetworklist = value.usernetworkslist;
          setState(() {});
        }
      }, onError: (covariant) {
        Constants.PopupDialog(context, "Server Not Responding!" + covariant.toString());
      });
    }
  }

  @override
  void dispose() {
    username.dispose();
    website.dispose();
    email.dispose();
    userphone.dispose();
    baddress.dispose();
    cusaddress.dispose();
    empname.dispose();
    worktitle.dispose();
    workemail.dispose();
    btype.dispose();
    _controllers.clear();
    _titleControllers.clear();
    about.dispose();
    comments.dispose();
    meetingtime.dispose();
    super.dispose();
  }

  CountryDialog(BuildContext context) {
    return AlertDialog(
      title: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: SDP.sdp(25),
              child: TextField(
                textAlign: TextAlign.center,
                enabled: false,
                decoration: InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  border: InputBorder.none,
                  filled: false,
                  fillColor: Color(0xFFF7F8FA),
                  hintText: 'Introduce With',
                  hintStyle: TextDesigner(
                      SDP.sdp(14), const Color(0xFFB492E8), 'm'),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: SDP.sdp(8)),
              height: SDP.sdp(28),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(SDP.sdp(3)),
                ),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey, blurRadius: .5, spreadRadius: .5),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  message = value;
                },
                decoration: InputDecoration(
                  contentPadding:EdgeInsets.only(left: SDP.sdp(8) , right: 0 , top: 0 , bottom: 0),
                  enabledBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(3))),
                    borderSide: const BorderSide(
                      color: Color(0xFFAAACAE),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(3))),
                    borderSide: const BorderSide(
                      color: Color(0xFFAAACAE),
                      width: 1,
                    ),
                  ),
                  filled: true,
                  fillColor: Color(0xFFFFFFFF),
                  hintText: 'Message',
                  hintStyle: TextDesigner(
                      SDP.sdp(10), const Color(0xFFAAACAE), 'r'),
                ),
              ),
            ),
          ],
        ),
      ),
      content: Container(
        width: SDP.sdp(500),
        height: SDP.sdp(250),
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: flist.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  shareFriendRequest(context, _fid!, flist[index].frienduserid.toString());
                },
                child: Container(
                  margin: EdgeInsets.all(SDP.sdp(5)),
                  height: SDP.sdp(30),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: SDP.sdp(3)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                            backgroundImage: flist[index].friendimage == ""
                                ? CachedNetworkImageProvider(
                                "http://mwsworkroom.com/YesYes/core/public/appusers/zappect-logo.png")
                                : CachedNetworkImageProvider(
                                flist[index].friendimage!)),
                        Container(
                          margin: EdgeInsets.only(left: SDP.sdp(10)),
                          child: SizedBox(
                            width: SDP.sdp(135),
                            child: Text(
                              flist[index].friendusername!,
                              style: TextDesigner(
                                  14, const Color(0xFF1A1C2D), 'r'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height: SDP.sdp(25),
                width: SDP.sdp(90),
                margin: EdgeInsets.only(top: SDP.sdp(10),bottom: SDP.sdp(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SDP.sdp(3)),
                  color: const Color(0xFFB492E8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cancel',
                      style: TextDesigner(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> shareFriendRequest(BuildContext context, String Bid, String Cid) async {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
    client.ShareProfile("807620388065912", Controls.id, Bid, Cid, message).then(
      (value) {
          if (value.code == "1") {
            Constants.ShowSnackBar(context, value.msg.toString());
          } else {
            Constants.PopupDialog(context, value.msg.toString());
          }
        }, onError: (covariant) {
           Constants.PopupDialog(context, "Check your internet Connection!");
    });
  }

  Future<void> _blockUser(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(
          Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.BlockUser("807620388065912", Controls.id, friends.connectionid.toString(), _fid!).then(
              (value) {
            Navigator.of(context).pop();
            Constants.ShowSnackBar(context, value.msg.toString());
            if (value.code == "1") {
              friends.blockstatus = 1;
              setState(() {});
            }
          }, onError: (covariant) {
        Navigator.of(context).pop();
        Constants.PopupDialog(
            context, "Server Not Responding!" + covariant.toString());
      });
    } else {
      Constants.PopupDialog(context, "Check Your Internet Connection");
    }
  }

  Future<void> _unblockUser(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(
          Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.UnBlockUser("807620388065912", Controls.id, friends.connectionid.toString(), _fid!).then(
              (value) {
            Navigator.of(context).pop();
            Constants.ShowSnackBar(context, value.msg.toString());
            if (value.code == "1") {
              friends.blockstatus = 0;
              setState(() {});
            }
          }, onError: (covariant) {
        Navigator.of(context).pop();
        Constants.PopupDialog(
            context, "Server Not Responding!" + covariant.toString());
      });
    } else {
      Constants.PopupDialog(context, "Check Your Internet Connection");
    }
  }

  Widget buildAccessTokenWarning() {
    return Container(
      color: Colors.red[900],
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Please pass in your access token with",
            "--dart-define=ACCESS_TOKEN=ADD_YOUR_TOKEN_HERE",
            "passed into flutter run or add it to args in vscode's launch.json",
          ]
              .map((text) => Padding(
            padding: EdgeInsets.all(8),
            child: Text(text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ))
              .toList(),
        ),
      ),
    );
  }

  void _acquireCurrentLocation() async {
    if (meetingloc != "") {
      _markers.clear();
      List<Placemark> placemarks = await placemarkFromCoordinates(double.tryParse(lat)!, double.tryParse(long)!);
      Placemark place = placemarks[0];
      baddress.text = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}';
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target:  meetingloc == "" ? LatLng(45.45, 45.45) : LatLng(double.tryParse(lat)!, double.tryParse(long)!),
            tilt: 59.440717697143555,
            zoom: 19.151926040649414,
          )
      ));
      _markers.add(
          Marker(
            markerId: const MarkerId('BID'),
            position:  meetingloc == "" ? LatLng(45.45, 45.45) : LatLng(double.tryParse(lat)!, double.tryParse(long)!),
            infoWindow: const InfoWindow(
                snippet: 'Long press to move marker',
                title: 'Meeting Location'
            ),)
      );
      setState(() {});
    }
  }

}

class ImageDialog extends StatelessWidget {

  String? link;

  ImageDialog({required this.link}) : super();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
          width: SDP.sdp(200),
          height: SDP.sdp(200),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(link!),
            ),
          )
      ),
    );
  }
}
