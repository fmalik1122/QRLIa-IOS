import 'dart:io';

import 'package:barcodeprinter/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import '../SDP.dart';
import '../api/api_client.dart';
import '../utils/controls.dart';
import 'Settings_2.dart';



class UpdatePass_2 extends StatefulWidget {

  String? email;

  UpdatePass_2({this.email}) : super();

  @override
  State<UpdatePass_2> createState() => _UpdatePass_2State(email);
}

class _UpdatePass_2State extends State<UpdatePass_2> {

  bool _textFieldSelected = false;
  String? oldpass = "", pass = "", email = "", cpass, imagename;
  bool onerror = false;
  bool allowemail = true;
  bool allowpass = false;
  bool _obscureText = true;
  String userphone = "";

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp? match;

  _UpdatePass_2State(String? _email) {
    email = _email;
  }

  @override
  void initState() {
    super.initState();
    match = new RegExp(pattern);
    if(email != ""){
      allowemail = false;
      allowpass = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      appBar:   AppBar(
        leading: null,
        backgroundColor: const Color(0xFFFFFFFF),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        title: Text(Controls.ispassword ? 'Create Password' : 'Change Password',
            style: TextDesigner(SDP.sdp(16), const Color(0xFFB492E8), 'b')),
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
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  children: [
                    Container(
                      width: _size.width - SDP.sdp(25),
                      height: SDP.sdp(30),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1.0, color:  onerror ? Colors.red : Colors.grey[300]!),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: SDP.sdp(30),
                            width: SDP.sdp(260),
                            alignment: Alignment.centerLeft,
                            child: Form(
                              key: formkey,
                              child: TextFormField(
                                enabled: allowemail,
                                onTap: () {
                                  _textFieldSelected = false;
                                  setState(() {});
                                },
                                validator: (kaka) {
                                  if(kaka!.length > 0){
                                    if (match!.hasMatch(kaka)) {
                                      setState(() {
                                        allowpass = true;
                                        onerror = false;});
                                      return null;
                                    }else{
                                      setState(() {
                                        allowpass = false;
                                        onerror = true;});
                                      return 'Enter valid email';
                                    }
                                  }else{
                                    setState(() {
                                      allowpass = false;
                                      onerror = false;});
                                    return null;
                                  }
                                },
                                onChanged: (text) {
                                  email = text;
                                  formkey.currentState!.validate();
                                },
                                decoration: InputDecoration(
                                  isDense: Platform.isIOS ? true : false,
                                  isCollapsed: Platform.isIOS ? true : false,
                                  contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.only(left: SDP.sdp(0) , right: 0 , top: SDP.sdp(0) , bottom: SDP.sdp(3)),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  filled: false,
                                  fillColor: const Color(0xFFF2F2F2),
                                  hintText: email == "" ? "Email" : email,
                                  hintStyle: email != "" ? TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r') : TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Controls.ispassword ? Container() : Container(
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
                          Container(
                            height: SDP.sdp(30),
                            width: SDP.sdp(275),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              textCapitalization: TextCapitalization.sentences,
                              onTap: () {
                                _textFieldSelected = false;
                                setState(() {});
                              },
                              onChanged: (text) {
                                oldpass = text;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: Platform.isIOS ? true : false,
                                isCollapsed: Platform.isIOS ? true : false,
                                contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.zero,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                filled: false,
                                fillColor: const Color(0xFFF2F2F2),
                                hintText: "Old Password",
                                hintStyle: TextDesigner(
                                    SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                                suffixIcon:IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                    color: const Color(0xFFB08BE7),
                                  ),
                                  onPressed: () {
                                    _toggle();
                                  },
                                ),
                              ),
                              obscureText: _obscureText,
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          Container(
                            height: SDP.sdp(30),
                            width: SDP.sdp(275),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              textCapitalization: TextCapitalization.sentences,
                              onTap: () {
                                _textFieldSelected = false;
                                setState(() {});
                              },
                              onChanged: (text) {
                                pass = text;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: Platform.isIOS ? true : false,
                                isCollapsed: Platform.isIOS ? true : false,
                                contentPadding: Platform.isIOS ? EdgeInsets.zero : EdgeInsets.zero,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                filled: false,
                                fillColor: const Color(0xFFF2F2F2),
                                hintText: "Password",
                                hintStyle: TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
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
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if(allowpass){
                          FocusManager.instance.primaryFocus!.unfocus();
                          bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
                          if(isConnected == true) {
                            if(Controls.ispassword){
                              if (pass != "") {
                                UpdatePassword(context);
                              }else{
                                Constants.ShowSnackBar(context, "Password Field is Empty");
                              }
                            }else{
                              if(oldpass == Controls.password){
                                if (pass != "") {
                                  UpdatePassword(context);
                                }else{
                                  Constants.ShowSnackBar(context, "Password Field is Empty");
                                }
                              }else{
                                Constants.ShowSnackBar(context, "Incorrect Old Password");
                              }
                            }
                          }
                          else {
                            Constants.ShowSnackBar(context, "Check Your Internet Connection!");
                          }
                        }else{
                          Constants.ShowSnackBar(context, "Please Set Email First");
                        }
                      },
                      child: Container(
                        height: SDP.sdp(40),
                        width: SDP.sdp(130),
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
                                'Save',
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
      ),
    );
  }

  UpdatePassword(BuildContext context) {
    Constants.Loading(context);
    final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
    client.YesYesConnectPassUpdateAPI("807620388065912", Controls.id, pass!, email!)
        .then((value) async {
      Navigator.pop(context);
      Constants.ShowSnackBar(context, value.msg!);
      if (value.code == "1") {
        final prefs = await SharedPreferences.getInstance();
        Controls.password = pass.toString();
        Controls.ispassword = false;
        await prefs.setString('password', pass.toString());
        await prefs.setBool('pass', false);
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {return Settings_2();}));
      }
    }, onError: (covariant) {
      Navigator.pop(context);
      Constants.ShowSnackBar(context, "Server Not Responding!");
    });
  }

  PopupDialog(BuildContext context, String msg) {
    return showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SDP.sdp(0)),
        ),
        context: context,
        builder: (context) => Container(
          height: SDP.sdp(150),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: SDP.sdp(5), right: SDP.sdp(5)),
                  child: Text(msg,
                      style: TextDesigner_L(SDP.sdp(14),
                          const Color(0xFF1A1C2D), 'r')),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {return Settings_2();
                    }));
                  },
                  child: Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(150),
                    margin: EdgeInsets.only(top: SDP.sdp(30), bottom: SDP.sdp(10)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SDP.sdp(8)),
                      color: const Color(0xFF6D6BDE),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SDP.sdp(10), right: SDP.sdp(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Close',
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
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}