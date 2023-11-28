import 'dart:convert';
import 'dart:io';
import 'package:barcodeprinter/Profile/Settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:async/async.dart';

import '../DataModers/NetworkListModel.dart';
import '../SDP.dart';
import '../api/api_client.dart';
import '../login/register.dart';
import '../utils/constants.dart';
import '../utils/controls.dart';
import 'BusinessPage.dart';
import 'EditProfile.dart';
import 'StatusScreen.dart';

class ProfilePage extends StatefulWidget {

  static const String ACCESS_TOKEN =
      "pk.eyJ1IjoiYWJjLTQ1Njc4IiwiYSI6ImNsZDl5ZHhzejA1MjQzbm5vcDc5Y3hhdXAifQ.fZ4bS1d1Xh_I4tbd0z8ATQ";

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _textFieldSelected = false;
  bool _editable = false;
  bool isSelected = false;
  final ImagePicker _picker = ImagePicker();
  File? image;
  Size? _size;
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
  String hnt = "Enter Url", accounttype = "User", userimage = "", handle = "", longitude = "", latitude = "", blongitude = "", blatitude = "";
  TextEditingController username = TextEditingController(), website = TextEditingController() , email = TextEditingController(),
   phone = TextEditingController(), baddress = TextEditingController(), cusaddress = TextEditingController(),qrtitle = TextEditingController() , empname = TextEditingController(),
   worktitle = TextEditingController(), workemail = TextEditingController(), btype = TextEditingController(),about = TextEditingController();

  @override
  void initState() {
    super.initState();
    Controls.isfirst = false;
    Controls.usernetworklist.clear();
    _getProfile(context);
    _getUserNetworkList(context);
    _getImageName();
  }

  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    _size = MediaQuery.of(context).size;
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      appBar: AppBar(
        leading: null,
        backgroundColor: const Color(0xFFFFFFFF),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        title: Text("Profile",
            style: TextDesigner(SDP.sdp(16), const Color(0xFFB492E8), 'b')),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) {
              if (value == "Logout") {
                _logout();
                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => Signup(),
                  ),
                      (route) =>
                  false, //if you want to disable back feature set to false
                );
              }else if(value == "Settings"){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Settings()));
              }else if(value == "Add Story"){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => StatusScreen()));
              } else{
                PopupDialog(context, "Are you sure you want to \n delete this account?");
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Add Story', 'Logout', 'Settings' , 'Delete Account'}.map((link) {
                return PopupMenuItem(
                  value: link,
                  child: Text(link),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        height: _size!.height,
        width: _size!.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Login/bg.png"), fit: BoxFit.cover)),
        padding: EdgeInsets.only(top: SDP.sdp(10), left: SDP.sdp(20), right: SDP.sdp(20)),
        child: SingleChildScrollView(
          child: Column(children: [
            GestureDetector(
              onTap: () async {},
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: SDP.sdp(60),
                        width: SDP.sdp(60),
                        margin: EdgeInsets.only(right: SDP.sdp(10)),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: userimage == ""
                                  ? NetworkImage("http://qrlia.com/core/public/appusers/qrliaface-icon.png")
                                  : NetworkImage(userimage),
                            ),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(SDP.sdp(10))),
                      ),
                      Column(
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
                          Container(
                            child: Text(
                              email.text,
                              style: TextDesigner(
                                  SDP.sdp(10), const Color(0xFFA9A9A9), 'r'),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => EditProfile())).then((value) => {
                                      Controls.usernetworklist.clear(),
                                      _getProfile(context),
                                      _getUserNetworkList(context),
                                      _getImageName()
                                  });
                                },
                                child: Container(
                                  height: SDP.sdp(18),
                                  width: SDP.sdp(80),
                                  margin: EdgeInsets.only(bottom: SDP.sdp(20), top: SDP.sdp(5)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(SDP.sdp(15)),
                                    color: const Color(0xFFB492E8),
                                  ),
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(left: SDP.sdp(10), right: SDP.sdp(15)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Edit Profile',
                                          style: TextDesigner(
                                              SDP.sdp(9), const Color(0xFFFFFFFF), 'r'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              accounttype == "Business" ? GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) => BusinessPage())).then((value) => {
                                  });
                                },
                                child: Container(
                                  height: SDP.sdp(18),
                                  width: SDP.sdp(90),
                                  margin: EdgeInsets.only(bottom: SDP.sdp(20), top: SDP.sdp(5), left:  SDP.sdp(5)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(SDP.sdp(15)),
                                    color: const Color(0xFFB492E8),
                                  ),
                                  child: Padding(
                                    padding:
                                    EdgeInsets.only(left: SDP.sdp(10), right: SDP.sdp(15)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Business Page',
                                          style: TextDesigner(
                                              SDP.sdp(9), const Color(0xFFFFFFFF), 'r'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ) : Container(),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: SDP.sdp(5)) ,
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
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
                    style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
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
                      hintText: "Name",
                      hintStyle: TextDesigner(
                          SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: SDP.sdp(5)) ,
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
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
                  controller: phone,
                  style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
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
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
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
                      style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
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
                        hintText:  accounttype == "Business" ? "Business name" : "Employer or Business or School name",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
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
                      style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
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
                        hintText: accounttype == "Business" ? "Title at Business" : "Title at work or school",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
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
                      style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
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
                        hintText: accounttype == "Business" ? "Email" : "Work or school or other email",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            accounttype == "Business" ? Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
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
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                      controller: btype,
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
                        hintText: "Business Type",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ) : Container(),
            accounttype == "Business" ? Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
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
                      style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
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
                        hintText: "Website",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ) : Container(),
            accounttype == "Business" ? Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
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
                      style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: false,
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
                        hintText: "Business Address",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ) : Container(),
            accounttype == "Business" ? Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
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
                      style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: false,
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
                        hintText: "Business Address(Custom)",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ) : Container(),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
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
                      style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: false,
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
                        hintText: "About - Add a few lines about yourself, personal interests, professional experience and achievements",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Controls.usernetworklist.isNotEmpty ? Container(
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
                itemCount: Controls.usernetworklist.length,
                itemBuilder: (BuildContext context, index) {
                  return GestureDetector(
                    onTap: () async {
                      if(Controls.usernetworklist[index].networktype == "custom"){
                        var url = "https://" + Controls.usernetworklist[index].networkvalue.toString();
                        // await launch(url);
                      }else{
                        var url = Controls.usernetworklist[index].networkurlforhandles.toString() + Controls.usernetworklist[index].networkvalue.toString();
                        // await launch(url);
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
                              Controls.usernetworklist[index].networkicon == ""
                                  ? NetworkImage(
                                  'http://qrlia.com/core/public/appusers/qrliaface-icon.png"')
                                  : NetworkImage(
                                  Controls.usernetworklist[index].networkicon!),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: SDP.sdp(10)),
                                  child: SizedBox(
                                    width: SDP.sdp(135),
                                    child: Text(
                                      Controls.usernetworklist[index].networkname == ""
                                          ? "QRLia"
                                          : Controls.usernetworklist[index].networkname!,
                                      style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: SDP.sdp(10)),
                                  child: SizedBox(
                                    width: SDP.sdp(135),
                                    child: Text(
                                      Controls.usernetworklist[index].networkname == ""
                                          ? "QrLia"
                                          : Controls.usernetworklist[index].networkvalue!,
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
          ]),
        ),
      ),
    );
  }

   _getProfile(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(
          Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.ProfileApi("807620388065912", Controls.id).then((value) {
        Navigator.of(context).pop();
        Controls.business = value;
        if (Controls.business.code == "1") {
          setState(() {
            username.text = Controls.business.name!;
            handle = Controls.business.username!;
            userimage = Controls.business.userimage!;
            qrtitle.text = Controls.business.qrtitle!;
            accounttype = Controls.business.accounttype!;
            empname.text = Controls.business.workbusinessname!;
            website.text = Controls.business.website!;
            phone.text = Controls.business.phone!;
            worktitle.text = Controls.business.worktitle!;
            workemail.text = Controls.business.workemail!;
            email.text = Controls.business.email!;
            btype.text = Controls.business.businesstype!;
            cusaddress.text = Controls.business.cusaddress!;
            about.text = Controls.business.about!;
            if (accounttype == "User") {
              isSelected = false;
            } else {
              isSelected = true;
            }
            if (isvirtual == "0") {
              virtualBusiness = false;
            } else {
              virtualBusiness = true;
            }
            _resetCounter();
          });
        } else {
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
          client.UserNetworkList("807620388065912", Controls.id).then(
              (value) {
            if (value.code == "1") {
              Controls.usernetworklist = value.usernetworkslist;
              setState(() {});
            }else{
              defaultNetworks();
            }
          }, onError: (covariant) {
          Constants.PopupDialog(context, "Server Not Responding!" + covariant.toString());
      });
    }
  }

  defaultNetworks() async {
    for (var i = 0; i <= 5; i++) {
      switch (i) {
        case 0:
          NetworkslistModel custom = NetworkslistModel();
          custom.networkid = 3;
          custom.networkvalue = "";
          custom.networkname = "Instagram";
          custom.networkformat =  "handle";
          custom.networkicon = "http://qrlia.com/core/public/connectnetworks/instagram.png";
          custom.networktype = "default";
          Controls.usernetworklist.add(custom);
          break;
        case 1:
          NetworkslistModel custom = NetworkslistModel();
          custom.networkid = 4;
          custom.networkvalue = "";
          custom.networkname = "LinkedIn";
          custom.networkformat =  "url";
          custom.networkicon = "http://qrlia.com/core/public/connectnetworks/linkedin.png";
          custom.networktype = "default";
          Controls.usernetworklist.add(custom);
          break;
        case 2:
          NetworkslistModel custom = NetworkslistModel();
          custom.networkid = 9;
          custom.networkvalue = "";
          custom.networkname = "TikTok";
          custom.networkformat =  "handle";
          custom.networkicon = "http://qrlia.com/core/public/connectnetworks/tiktok.png";
          custom.networktype = "default";
          Controls.usernetworklist.add(custom);
          break;
        case 3:
          NetworkslistModel custom = NetworkslistModel();
          custom.networkid = 7;
          custom.networkvalue = "";
          custom.networkname = "Twitter";
          custom.networkformat =  "handle";
          custom.networkicon = "http://qrlia.com/core/public/connectnetworks/twitter.png";
          custom.networktype = "default";
          Controls.usernetworklist.add(custom);
          break;
        case 4:
          NetworkslistModel custom = NetworkslistModel();
          custom.networkid = 6;
          custom.networkvalue = "";
          custom.networkname = "Youtube";
          custom.networkformat =  "handle";
          custom.networkicon = "http://qrlia.com/core/public/connectnetworks/youtube.png";
          custom.networktype = "default";
          Controls.usernetworklist.add(custom);
          break;
      }
    }
    setState(() {});
  }

  delete(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(
          Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.DeleteApi("807620388065912", Controls.id).then((value) {
        Navigator.of(context).pop();
        if (value.code == "1") {
          Constants.PopupDialog(context, value.msg!);
          _logout();
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => Signup(),
            ),
                (route) =>
            false, //if you want to disable back feature set to false
          );
        } else {
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

  Future<void> _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    Controls.userimgname = imagename!;
    Controls.username = username.text;
    await prefs.setString('userimgname', imagename!);
    await prefs.setString('userimgname', imagename!);
    await prefs.setString('username', username.text);
  }

  Future<void> _getImageName() async {
    final pref = await SharedPreferences.getInstance();
    imagename = pref.getString('userimgname') ?? "";
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    Controls.bottomIndex = 0;
    Controls.id = "0";
    Controls.handle = "";
    Controls.timeDuration = "";
    Controls.password = "";
    Controls.ispassword = true;
    Controls.isfirst = true;
    Controls.userimg = "";
    Controls.username = "";
    await prefs.setString('userid', "0");
    await prefs.setString('password', " ");
    await prefs.setBool('pass', true);
    await prefs.setString('userimage', "");
    await prefs.setString('userimgname', "");
  }

  PopupDialog(BuildContext context, String msg) {
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
                Text(msg,
                    textAlign: TextAlign.center,
                    style: TextDesigner_L(SDP.sdp(14), const Color(0xFF1A1C2D), 'r')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        delete(context);
                      },
                      child: Container(
                        height: SDP.sdp(30),
                        width: SDP.sdp(100),
                        margin: EdgeInsets.only(top: SDP.sdp(20), right : SDP.sdp(10)),
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
                                'Yes',
                                style: TextDesigner_L(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: SDP.sdp(30),
                        width: SDP.sdp(100),
                        margin: EdgeInsets.only(top: SDP.sdp(20)),
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
                                'No',
                                style: TextDesigner_L(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }

  @override
  void dispose() {
    username.dispose();
    qrtitle.dispose();
    website.dispose();
    email.dispose();
    phone.dispose();
    baddress.dispose();
    cusaddress.dispose();
    empname.dispose();
    worktitle.dispose();
    workemail.dispose();
    btype.dispose();
    _controllers.clear();
    _titleControllers.clear();
    super.dispose();
  }
}
