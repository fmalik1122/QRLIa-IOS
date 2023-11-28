import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import '../SDP.dart';
import '../api/api_client.dart';
import '../bottam navigation/BottomNavigation.dart';
import '../provider/business_provider.dart';
import '../utils/constants.dart';
import '../utils/controls.dart';
import 'UpdatePassword.dart';

class Settings_2 extends StatefulWidget {

  Settings_2() : super();

  @override
  State<Settings_2> createState() => _Settings_2State();
}

class _Settings_2State extends State<Settings_2> {

  String? email;
  String accounttype = "User";

  bool _textFieldSelected = false;

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

  @override
  void initState() {
    super.initState();
    _getSettings(context);
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
        title:  Text(
            'Settings',
            style: TextDesigner(SDP.sdp(16), const Color(0xFFB492E8), 'b')
        ),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus;
        },
        child: Container(
          height: _size.height,
          width: _size.width,
          padding: EdgeInsets.only(top: SDP.sdp(0),left: SDP.sdp(10),right: SDP.sdp(10)),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Login/bg.png"),
                  fit: BoxFit.cover
              )
          ),
          child: SingleChildScrollView(
            child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: SDP.sdp(15), left: SDP.sdp(2)),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Sharing Settings',
                      style: TextDesigner(SDP.sdp(12),const Color(0xFF000000),'b'),
                    ),
                  ),
                  Container(
                    width: _size.width - SDP.sdp(25),
                    height: SDP.sdp(60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: SDP.sdp(2) ),
                              child: Text(
                                'Allow profile introduction',
                                style: TextDesigner(
                                    SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                              ),
                            ),
                            Container(
                              child: Text(
                                'Allow your friends to introduce you to their \ncontacts',
                                style: TextDesigner(
                                    SDP.sdp(9), Colors.grey, 'r'),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          height: SDP.sdp(23),
                          child: FlutterSwitch(
                            activeText: "Yes",
                            inactiveText: "No",
                            activeTextColor: Color(0xFFB492E8),
                            inactiveTextColor: Color(0xFFB492E8),
                            value: profilesharing,
                            valueFontSize: SDP.sdp(9),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white,
                            activeToggleColor: Color(0xFFB492E8),
                            inactiveToggleColor: Color(0xFFB492E8),
                            activeSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            inactiveSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            width: SDP.sdp(50),
                            borderRadius: SDP.sdp(15),
                            showOnOff: true,
                            onToggle: (val) {
                              setState(() {
                                if (val) {
                                  profilesharing = val;
                                  _profilesharing = "1";
                                } else {
                                  profilesharing = val;
                                  _profilesharing = "0";
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: SDP.sdp(5), left: SDP.sdp(2)),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Web (public) Profile Settings',
                      style: TextDesigner(SDP.sdp(12),const Color(0xFF000000),'b'),
                    ),
                  ),
                  Container(
                    width: _size.width - SDP.sdp(25),
                    height: SDP.sdp(40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Create Web Profile',
                            style: TextDesigner(
                                SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          height: SDP.sdp(23),
                          child: FlutterSwitch(
                            activeText: "Yes",
                            inactiveText: "No",
                            activeTextColor: Color(0xFFB492E8),
                            inactiveTextColor: Color(0xFFB492E8),
                            value: webprofile,
                            valueFontSize: SDP.sdp(9),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white,
                            activeToggleColor: Color(0xFFB492E8),
                            inactiveToggleColor: Color(0xFFB492E8),
                            activeSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            inactiveSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            width: SDP.sdp(50),
                            borderRadius: SDP.sdp(15),
                            showOnOff: true,
                            onToggle: (val) {
                              setState(() {
                                if (val) {
                                  webprofile = val;
                                  _webprofile = "1";
                                } else {
                                  webprofile = val;
                                  _webprofile = "0";
                                  sociallinks = val;
                                  _sociallinks = "0";
                                  ppicture = val;
                                  _ppicture = "0";
                                  location = val;
                                  _location = "0";
                                  phonenumber = val;
                                  _phonenumber = "0";
                                  businessemail = val;
                                  _businessemail = "0";
                                  companyname = val;
                                  _companyname = "0";
                                  worktitle = val;
                                  _worktitle = "0";
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: _size.width - SDP.sdp(25),
                    height: SDP.sdp(40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Display Social Links in Web Profile',
                            style: TextDesigner(
                                SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          height: SDP.sdp(23),
                          child: FlutterSwitch(
                            activeText: "Yes",
                            inactiveText: "No",
                            activeTextColor: Color(0xFFB492E8),
                            inactiveTextColor: Color(0xFFB492E8),
                            value: sociallinks,
                            valueFontSize: SDP.sdp(9),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white,
                            activeToggleColor: Color(0xFFB492E8),
                            inactiveToggleColor: Color(0xFFB492E8),
                            activeSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            inactiveSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            width: SDP.sdp(50),
                            borderRadius: SDP.sdp(15),
                            showOnOff: true,
                            onToggle: (val) {
                              setState(() {
                                if (val) {
                                  sociallinks = val;
                                  _sociallinks = "1";
                                } else {
                                  sociallinks = val;
                                  _sociallinks = "0";
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: _size.width - SDP.sdp(25),
                    height: SDP.sdp(40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Display Profile Picture in Web Profile',
                            style: TextDesigner(
                                SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          height: SDP.sdp(23),
                          child: FlutterSwitch(
                            activeText: "Yes",
                            inactiveText: "No",
                            activeTextColor: Color(0xFFB492E8),
                            inactiveTextColor: Color(0xFFB492E8),
                            value: ppicture,
                            valueFontSize: SDP.sdp(9),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white,
                            activeToggleColor: Color(0xFFB492E8),
                            inactiveToggleColor: Color(0xFFB492E8),
                            activeSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            inactiveSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            width: SDP.sdp(50),
                            borderRadius: SDP.sdp(15),
                            showOnOff: true,
                            onToggle: (val) {
                              setState(() {
                                if (val) {
                                  ppicture = val;
                                  _ppicture = "1";
                                } else {
                                  ppicture = val;
                                  _ppicture = "0";
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  accounttype == "Business" ? Container(
                    width: _size.width - SDP.sdp(25),
                    height: SDP.sdp(40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Display  Business Location',
                            style: TextDesigner(
                                SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          height: SDP.sdp(23),
                          child: FlutterSwitch(
                            activeText: "Yes",
                            inactiveText: "No",
                            activeTextColor: Color(0xFFB492E8),
                            inactiveTextColor: Color(0xFFB492E8),
                            value: location,
                            valueFontSize: SDP.sdp(9),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white,
                            activeToggleColor: Color(0xFFB492E8),
                            inactiveToggleColor: Color(0xFFB492E8),
                            activeSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            inactiveSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            width: SDP.sdp(50),
                            borderRadius: SDP.sdp(15),
                            showOnOff: true,
                            onToggle: (val) {
                              setState(() {
                                if (val) {
                                  location = val;
                                  _location = "1";
                                } else {
                                  location = val;
                                  _location = "0";
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ) : Container(),
                  Container(
                    width: _size.width - SDP.sdp(25),
                    height: SDP.sdp(40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Display Phone Number Web Profile',
                            style: TextDesigner(
                                SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          height: SDP.sdp(23),
                          child: FlutterSwitch(
                            activeText: "Yes",
                            inactiveText: "No",
                            activeTextColor: Color(0xFFB492E8),
                            inactiveTextColor: Color(0xFFB492E8),
                            value: phonenumber,
                            valueFontSize: SDP.sdp(9),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white,
                            activeToggleColor: Color(0xFFB492E8),
                            inactiveToggleColor: Color(0xFFB492E8),
                            activeSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            inactiveSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            width: SDP.sdp(50),
                            borderRadius: SDP.sdp(15),
                            showOnOff: true,
                            onToggle: (val) {
                              setState(() {
                                if (val) {
                                  phonenumber = val;
                                  _phonenumber = "1";
                                } else {
                                  phonenumber = val;
                                  _phonenumber = "0";
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: _size.width - SDP.sdp(25),
                    height: SDP.sdp(40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Display Email Address in Web Profile',
                            style: TextDesigner(
                                SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          height: SDP.sdp(23),
                          child: FlutterSwitch(
                            activeText: "Yes",
                            inactiveText: "No",
                            activeTextColor: Color(0xFFB492E8),
                            inactiveTextColor: Color(0xFFB492E8),
                            value: businessemail,
                            valueFontSize: SDP.sdp(9),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white,
                            activeToggleColor: Color(0xFFB492E8),
                            inactiveToggleColor: Color(0xFFB492E8),
                            activeSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            inactiveSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            width: SDP.sdp(50),
                            borderRadius: SDP.sdp(15),
                            showOnOff: true,
                            onToggle: (val) {
                              setState(() {
                                if (val) {
                                  businessemail = val;
                                  _businessemail = "1";
                                } else {
                                  businessemail = val;
                                  _businessemail = "0";
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: _size.width - SDP.sdp(25),
                    height: SDP.sdp(40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Display Business / School name \nin Web Profile',
                            style: TextDesigner(
                                SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          height: SDP.sdp(23),
                          child: FlutterSwitch(
                            activeText: "Yes",
                            inactiveText: "No",
                            activeTextColor: Color(0xFFB492E8),
                            inactiveTextColor: Color(0xFFB492E8),
                            value: companyname,
                            valueFontSize: SDP.sdp(9),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white,
                            activeToggleColor: Color(0xFFB492E8),
                            inactiveToggleColor: Color(0xFFB492E8),
                            activeSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            inactiveSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            width: SDP.sdp(50),
                            borderRadius: SDP.sdp(15),
                            showOnOff: true,
                            onToggle: (val) {
                              setState(() {
                                if (val) {
                                  companyname = val;
                                  _companyname = "1";
                                } else {
                                  companyname = val;
                                  _companyname = "0";
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: _size.width - SDP.sdp(25),
                    height: SDP.sdp(40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Display Title at Work or School \nin Web Profile',
                            style: TextDesigner(
                                SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          height: SDP.sdp(23),
                          child: FlutterSwitch(
                            activeText: "Yes",
                            inactiveText: "No",
                            activeTextColor: Color(0xFFB492E8),
                            inactiveTextColor: Color(0xFFB492E8),
                            value: worktitle,
                            valueFontSize: SDP.sdp(9),
                            activeColor: Colors.white,
                            inactiveColor: Colors.white,
                            activeToggleColor: Color(0xFFB492E8),
                            inactiveToggleColor: Color(0xFFB492E8),
                            activeSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            inactiveSwitchBorder: Border.all(
                              color: Color(0xFFB492E8),
                              width: .5,
                            ),
                            width: SDP.sdp(50),
                            borderRadius: SDP.sdp(15),
                            showOnOff: true,
                            onToggle: (val) {
                              setState(() {
                                if (val) {
                                  worktitle = val;
                                  _worktitle = "1";
                                } else {
                                  worktitle = val;
                                  _worktitle = "0";
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () async {
          FocusManager.instance.primaryFocus!.unfocus();
          bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
          if(isConnected == true) {
            UpdateSettings(context);
          }
          else {
            Constants.ShowSnackBar(context, "Check your internet Connection!");
          }
        },
        child: Container(
          height: SDP.sdp(40),
          width: SDP.sdp(130),
          margin: EdgeInsets.only(top: SDP.sdp(10), bottom: SDP.sdp(20), left: SDP.sdp(20), right: SDP.sdp(20)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SDP.sdp(15)),
            color: const Color(0xFFB492E8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Save',
                style: TextDesigner(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  UpdateSettings(BuildContext context) {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
    Constants.Loading(context);
    client.UpdateSettingsRequest("807620388065912",email!,_webprofile,_ppicture,_sociallinks, _location, _phonenumber, _businessemail, _companyname, _worktitle , _profilesharing, Controls.id).then((value){
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      if(value.code == "1") {
        Constants.ShowSnackBar(context, value.msg!);
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => BottomNavigation(),
          ), (route) =>
        false, //if you want to disable back feature set to false
        );
      }
      else {
        Constants.PopupDialog(context,value.msg!);
      }
    },
        onError: (covariant){
          Navigator.of(context).pop();
          Constants.PopupDialog(context,"Server Not Responding!");
        });
  }

  _getSettings(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if(isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.GetSettingsRequest("807620388065912", Controls.id).then((value) {

        Navigator.of(context).pop();
        if(value.code == "1")
        {
          email = value.email;
          accounttype = value.accounttype!;

          if(value.webprofileshow.toString() == "1"){
            webprofile = true;
            _webprofile = value.webprofileshow!.toString();
          }else{
            webprofile = false;
            _webprofile = value.webprofileshow!.toString();
          }

          if(value.sociallinksshow.toString() == "1"){
            sociallinks = true;
            _sociallinks = value.sociallinksshow!.toString();
          }else{
            sociallinks = false;
            _sociallinks = value.sociallinksshow!.toString();
          }

          if(value.profileshare.toString() == "1"){
            profilesharing = true;
            _profilesharing = value.profileshare.toString();
          }else{
            profilesharing = false;
            _profilesharing = value.profileshare.toString();
          }

          if(value.profilepicshow.toString() == "1"){
            ppicture = true;
            _ppicture = value.profilepicshow!.toString();
          }else{
            ppicture = false;
            _ppicture = value.profilepicshow!.toString();
          }

          if(value.locationshow.toString() == "1"){
            location = true;
            _location = value.locationshow!.toString();
          }else{
            location = false;
            _location = value.locationshow.toString();
          }

          if(value.phonenumbershow.toString() == "1"){
            phonenumber = true;
            _phonenumber = value.phonenumbershow.toString();
          }else{
            phonenumber = false;
            _phonenumber = value.phonenumbershow.toString();
          }

          if(value.businessemail.toString() == "1"){
            businessemail = true;
            _businessemail = value.businessemail!.toString();
          }else{
            businessemail = false;
            _businessemail = value.businessemail!.toString();
          }

          if(value.companyname.toString() == "1"){
            companyname = true;
            _companyname = value.companyname!.toString();
          }else{
            companyname = false;
            _companyname = value.companyname!.toString();
          }

          if(value.worktitle.toString() == "1"){
            worktitle = true;
            _worktitle = value.worktitle!.toString();
          }else{
            worktitle = false;
            _worktitle = value.worktitle!.toString();
          }
          setState(() {});
        }
        else {
          Constants.PopupDialog(context,value.msg!);
        }
      },
      onError: (covariant){
        Navigator.of(context).pop();
        Constants.PopupDialog(context,"Server Not Responding!" + covariant.toString());
      });
    }else{
        Constants.PopupDialog(context,"Check your internet Connection!");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}