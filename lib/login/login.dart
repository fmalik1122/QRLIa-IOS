import 'dart:io';

import 'package:barcodeprinter/DataModers/Register.dart';
import 'package:barcodeprinter/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import '../SDP.dart';
import '../api/api_client.dart';
import '../bottam navigation/BottomNavigation.dart';
import '../homepage.dart';
import '../utils/controls.dart';

class Signin extends StatefulWidget {
  Signin() : super();

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  bool _obscureText = true;

  String? gid, firstname, lastname;

  TextDesigner(double _fSize, Color _fColor,String _fFamily){
    TextStyle _textStyle = TextStyle(
        fontSize: _fSize,
        color: _fColor,
        fontFamily: (_fFamily == 'R' || _fFamily == 'r') ? 'Poppins-Regular':(_fFamily == 'B' || _fFamily == 'b') ? 'Poppins-Bold':'Poppins-Medium'
    );
    return _textStyle;
  }

  String? email, password;

  Future<void> _resetCounter(String newuserid, String passo) async {
    final prefs = await SharedPreferences.getInstance();
    Controls.password = passo;
    Controls.ispassword = false;
    await prefs.setString('userid', newuserid);
    await prefs.setString('handle', Controls.handle);
    await prefs.setString('password', passo);
    await prefs.setBool('pass', false);
  }

  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    SystemChrome.setEnabledSystemUIOverlays ([]);
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        extendBodyBehindAppBar: true,
        drawerScrimColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFF),
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
          title:  Text(
            'Sign In',
            style: TextDesigner(SDP.sdp(16), const Color(0xFFB492E8), 'b')
          ),
        ),
        body: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image:AssetImage("assets/Login/bg.png"),
                  fit: BoxFit.cover
              )
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      padding: const EdgeInsets.only( left: 20.0, right: 20.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(bottom: SDP.sdp(3)),
                            child: Text(
                              'Email',
                              style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                            ),
                          ),
                          Container(
                            height: SDP.sdp(30),
                            width: size.width - SDP.sdp(25) ,
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              onChanged: (text){
                                email = text;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: SDP.sdp(10), right: SDP.sdp(0), top: SDP.sdp(0), bottom: SDP.sdp(0)),
                                enabledBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(8))),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFB492E8),
                                    width: .2,
                                  ),
                                ),
                                focusedBorder:  OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(8))),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFB492E8),
                                    width: .2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF7F8FA),
                                hintText: 'Enter Email',
                                hintStyle: TextDesigner(SDP.sdp(10),const Color(0xFFAAACAE),'r'),

                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: SDP.sdp(5)),
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(bottom: SDP.sdp(3)),
                            child: Text(
                              'Password',
                              style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                            ),
                          ),
                          Container(
                            height: SDP.sdp(30),
                            width: size.width - SDP.sdp(25) ,
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              onChanged: (text){
                                password = text;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: SDP.sdp(10), right: SDP.sdp(0), top: SDP.sdp(0), bottom: SDP.sdp(0)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(8))),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFB492E8),
                                    width: .2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(8))),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFB492E8),
                                    width: .2,
                                  ),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF7F8FA),
                                hintText: 'Enter Password',
                                hintStyle: TextDesigner(SDP.sdp(10),const Color(0xFFAAACAE),'r'),
                                suffixIcon:IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                    color: const Color(0xFFB08BE7),
                                  ),
                                  onPressed: () {
                                   _toggle();
                                  },
                              ),),
                              obscureText: _obscureText,
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () async {
                              if(email == null||password == null)
                              {
                                Constants.ShowSnackBar(context,"Recheck all fields!");
                              }
                              else
                              {
                                bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
                                Constants.Loading(context);
                                if(isConnected == true)
                                {
                                  AccessAccount(context);
                                }
                                else
                                {
                                  Navigator.pop(context);
                                  Constants.PopupDialog(context,"Check your internet Connection!");
                                }
                              }
                            },
                            child:
                            Container(
                              height: SDP.sdp(35),
                              width: SDP.sdp(150),
                              margin: EdgeInsets.only(top: SDP.sdp(20)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(SDP.sdp(8)),
                                color: const Color(0xFFB492E8),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: SDP.sdp(10),right: SDP.sdp(15)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Sign In',
                                      style: TextDesigner(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  SizedBox(height: SDP.sdp(5),),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            'Don’t have an account?',
                            style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r')
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Text(
                              ' Register Now',
                              style: TextDesigner(SDP.sdp(11),const Color(0xFFB492E8),'r')
                          ),
                        )
                      ]
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  AccessAccount(BuildContext context) {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
    client.LoginAPI('807620388065912', email!, password!, Platform.isIOS ? '1' : '0' , Controls.firebaseToken).then((value){
      Navigator.of(context).pop();
      Constants.ShowSnackBar(context, value.msg!);
      if(value.code == "1")
      {
        Controls.id = value.userid.toString();
        Controls.isfirst = false;
        Controls.handle = value.username!;
        print(value.userid);
        _resetCounter(Controls.id, password!);
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => BottomNavigation(),
          ), (route) =>
          false, //if you want to disable back feature set to false
        );
      }
      else
      {}
    },
    onError: (covariant){
      Navigator.of(context).pop();
      Constants.PopupDialog(context,"Server Not Responding!" + covariant.toString());
    });
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}