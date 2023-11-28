import 'dart:io';

import 'package:barcodeprinter/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../SDP.dart';
import '../api/api_client.dart';
import '../bottam navigation/BottomNavigation.dart';
import '../utils/controls.dart';
import 'Settings_2.dart';
import 'UpdatePassword.dart';
import 'UpdatePassword_2.dart';

class Settings_1_Page extends StatefulWidget {

  Settings_1_Page() : super();

  @override
  State<Settings_1_Page> createState() => _Settings_1_PageState();
}

class _Settings_1_PageState extends State<Settings_1_Page> {

  bool _textFieldSelected = false;
  bool onerror = false;
  bool allowpass = false;
  String? pass = "", cpass, imagename;
  String? username = "",
      userimage = "",
      email = "",
      address = "",
      longitude = "",
      latitude = "",
      accounttype = "User",
      baddress = "",
      blongitude = "",
      weblink = "http://qrlia.com/",
      blatitude = "";

  bool webprofile = true;
  String _webprofile = "1";
  bool sociallinks = true;
  String _sociallinks = "1";
  bool ppicture = true;
  String _ppicture = "1";
  bool location = false;
  String _location = "0";
  bool phonenumber = false;
  String _phonenumber = "0";
  bool profilesharing = true;
  String _profilesharing = "1";

  bool businessemail = true;
  String _businessemail = "1";
  bool companyname = true;
  String _companyname = "1";
  bool worktitle = true;
  String _worktitle = "1";

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp? match;

  @override
  void initState() {
    super.initState();
    match = new RegExp(pattern);
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
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        title: Text('Settings',
            style: TextDesigner(SDP.sdp(16), const Color(0xFFB492E8), 'b')),
      ),
      body: Container(
        height: _size.height,
        width: _size.width,
        padding: EdgeInsets.only(top: SDP.sdp(0),left: SDP.sdp(10),right: SDP.sdp(10)),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Login/bg.png"),
                fit: BoxFit.cover
            )
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
                children: [
                  Container(
                    width: _size.width - SDP.sdp(25),
                    height: SDP.sdp(30),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            var url = weblink! + Controls.handle;
                            await launch(url);
                          },
                          child: Container(
                            height: SDP.sdp(30),
                            width: SDP.sdp(250),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                              textCapitalization: TextCapitalization.sentences,
                              enabled: false,
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
                                hintText: "www.qrlia.com/" + Controls.handle,
                                hintStyle: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: SDP.sdp(11),
                                    color: Colors.blue,
                                    fontFamily: 'Poppins-Regular'
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      FocusManager.instance.primaryFocus!.unfocus();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => UpdatePass_2(email: email))).then((value) =>{
                          setState(() {})
                      });
                    },
                    child: Container(
                      height: SDP.sdp(40),
                      width: SDP.sdp(220),
                      margin: EdgeInsets.only(top: SDP.sdp(10)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(SDP.sdp(15)),
                        color: Controls.ispassword ? Colors.red : const Color(0xFFB492E8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: SDP.sdp(10),right: SDP.sdp(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text( Controls.ispassword ? "Secure Account - Create Password" : 'Change Password',
                              style: TextDesigner(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }

}