import 'dart:io';

import 'package:barcodeprinter/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Profile/Settings_1.dart';
import '../Profile/Settings_3.dart';
import '../SDP.dart';
import '../api/api_client.dart';
import '../bottam navigation/BottomNavigation.dart';
import '../homepage.dart';
import '../utils/controls.dart';


class OtpScreen extends StatefulWidget {

  String number;
  String register;
  String code;

  OtpScreen({required this.number , required this.register, required this.code }) : super();

  @override
  State<OtpScreen> createState() => _OtpScreenState(number, register, code);
}

class _OtpScreenState extends State<OtpScreen> {

  String? vid;
  String? number;
  String? register;
  String? code;

  bool canResend = true;
  final TextEditingController _val1 = TextEditingController();
  final TextEditingController _val2 = TextEditingController();
  final TextEditingController _val3 = TextEditingController();
  final TextEditingController _val4 = TextEditingController();
  final TextEditingController _val5 = TextEditingController();
  final TextEditingController _val6 = TextEditingController();
  String number1 = "";
  String number2 = "";
  String number3 = "";
  String number4 = "";
  String number5 = "";
  String number6 = "";

  TextDesigner(double _fSize, Color _fColor, String _fFamily) {
    TextStyle _textStyle = TextStyle(
        fontSize: _fSize,
        color: _fColor,
        fontFamily: (_fFamily == 'R' || _fFamily == 'r')
            ? 'Poppins-Regular'
            : (_fFamily == 'B' || _fFamily == 'b')
            ? 'Poppins-Bold'
            : 'Poppins-Medium'
    );
    return _textStyle;
  }

  _OtpScreenState(String _number , String reg, String cde) {
    number = _number;
    register = reg;
    code = cde;
  }

  TextFieldBuilder() {
    return Container(
      height: SDP.sdp(30),
      width: SDP.sdp(30),
      child: TextField(
        //maxLength: 1,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(
              color: Color(0xFFE5806F),
              width: 0,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(
              color: Color(0xFFE5806F),
              width: 1.5,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(SDP.sdp(3)),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    signUpWithPhone(context);
  }

  @override
  void dispose() {
    _val1.dispose();
    _val2.dispose();
    _val3.dispose();
    _val4.dispose();
    _val5.dispose();
    _val6.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    SystemChrome.setEnabledSystemUIOverlays([]);
    Size size = MediaQuery.of(context).size;
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
              'Verification Code',
              style: TextDesigner(SDP.sdp(16), const Color(0xFFB492E8), 'b')
          ),
        ),
        body: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Login/bg.png"),
                  fit: BoxFit.cover
              )
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(bottom: SDP.sdp(10)),
                            child: Text(
                                'Verification Code',
                                style: TextDesigner(SDP.sdp(16), const Color(0xFF1A1C2D), 'b')
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: SDP.sdp(50),
                                width: SDP.sdp(25) ,
                                child: Focus(
                                  canRequestFocus: false,
                                  onFocusChange: (hasFocus) {
                                    if(hasFocus){
                                      _val1.text = "";
                                    }
                                  },
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    controller: _val1,
                                    onChanged: (val){
                                      if(val.isNotEmpty){
                                        number1 = val;
                                        FocusScope.of(context).nextFocus();
                                      }
                                      else{
                                        // FocusScope.of(context).previousFocus();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding: const EdgeInsets.all(0),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(5))),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFAAACAE),
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(5))),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFB492E8),
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFF7F8FA),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: SDP.sdp(50),
                                width: SDP.sdp(25) ,
                                child: Focus(
                                  canRequestFocus: false,
                                  onFocusChange: (hasFocus) {
                                    if(hasFocus){
                                      _val2.text = "";
                                    }
                                  },
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    controller: _val2,
                                    onChanged: (val){
                                      if(val.isNotEmpty){
                                        number2 = val;
                                        FocusScope.of(context).nextFocus();
                                      }
                                      else{
                                        // FocusScope.of(context).previousFocus();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding: const EdgeInsets.all(0),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(5))),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFAAACAE),
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(5))),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFB492E8),
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFF7F8FA),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: SDP.sdp(50),
                                width: SDP.sdp(25) ,
                                child: Focus(
                                  canRequestFocus: false,
                                  onFocusChange: (hasFocus) {
                                    if(hasFocus){
                                      _val3.text = "";
                                    }
                                  },
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    controller: _val3,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (val){
                                      if(val.isNotEmpty){
                                        number3 = val;
                                        FocusScope.of(context).nextFocus();
                                      }
                                      else{
                                        // FocusScope.of(context).previousFocus();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding: const EdgeInsets.all(0),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(5))),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFAAACAE),
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(5))),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFB492E8),
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFF7F8FA),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: SDP.sdp(50),
                                width: SDP.sdp(25) ,
                                child: Focus(
                                  canRequestFocus: false,
                                  onFocusChange: (hasFocus) {
                                    if(hasFocus){
                                      _val4.text = "";
                                    }
                                  },
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    controller: _val4,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (val){
                                      if(val.isNotEmpty){
                                        number4 = val;
                                        FocusScope.of(context).nextFocus();
                                      }
                                      else{
                                        // FocusScope.of(context).previousFocus();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding: const EdgeInsets.all(0),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(5))),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFAAACAE),
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(5))),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFB492E8),
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFF7F8FA),
                                    ),
                                  ),
                                ),

                              ),
                              Container(
                                height: SDP.sdp(50),
                                width: SDP.sdp(25) ,
                                child: Focus(
                                  canRequestFocus: false,
                                  onFocusChange: (hasFocus) {
                                    if(hasFocus){
                                      _val5.text = "";
                                    }
                                  },
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    autofocus: true,
                                    keyboardType: TextInputType.number,
                                    controller: _val5,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (val){
                                      if(val.isNotEmpty){
                                        number5 = val;
                                        FocusScope.of(context).nextFocus();
                                      }
                                      else{
                                        // FocusScope.of(context).previousFocus();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding: const EdgeInsets.all(0),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(5))),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFAAACAE),
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(5))),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFB492E8),
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFF7F8FA),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: SDP.sdp(50),
                                width: SDP.sdp(25) ,
                                child: Focus(
                                  canRequestFocus: false,
                                  onFocusChange: (hasFocus) {
                                    if(hasFocus){
                                      _val6.text = "";
                                    }
                                  },
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    controller: _val6,
                                    textInputAction: TextInputAction.next,
                                    onChanged: (val){
                                      if(val.isNotEmpty){
                                        number6 = val;
                                        FocusScope.of(context).unfocus();
                                      }
                                      else{
                                        // FocusScope.of(context).previousFocus();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      counterText: "",
                                      contentPadding: const EdgeInsets.all(0),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(5))),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFAAACAE),
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(5))),
                                        borderSide: const BorderSide(
                                          color: Color(0xFFB492E8),
                                          width: 2,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFF7F8FA),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          canResend ? Container(
                            margin: EdgeInsets.only(top: SDP.sdp(30)),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {});
                                      // signUpWithPhone(context);
                                    },
                                    child: Text(
                                        'Resend Code',
                                        style: TextDesigner(SDP.sdp(11),const Color(0xFFB492E8),'r')
                                    ),
                                  )
                                ]
                            ),
                          ) : Container(),
                          Container(
                            margin: EdgeInsets.only(top: SDP.sdp(15)),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                if (!(number1 == "") || !(number2 == "")  || !(number3 == "") || !(number4 == "") || !(number5 == "") || !(number6 == "")) {
                                  Constants.Loading(context);
                                  FirebaseAuth auth = FirebaseAuth.instance;
                                  PhoneAuthCredential credential = PhoneAuthProvider
                                      .credential(verificationId: vid!, smsCode: number1+number2+number3+number4+number5+number6);
                                  auth.signInWithCredential(credential).then((value) {
                                    if(register == "Regiter"){
                                      CreateAccount(context);
                                    }else{}
                                  }).onError((error, stackTrace) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text("Invalid Code"),
                                    ));
                                  });
                                }
                              },
                              child: Container(
                                height: SDP.sdp(35),
                                width: SDP.sdp(150),
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
                                        'Submit',
                                        style: TextDesigner(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),),
          ),
        )
    );
  }

  Future<void> signUpWithPhone(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if(Controls.timeDuration == ""){
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        timeout: const Duration(seconds: 60),
        verificationFailed: (FirebaseAuthException e) {
          Constants.PopupDialog(context,"Code Not Sent");
        },
        codeSent: (String? verificationId, int? resendToken) async {
          vid = verificationId;
          Controls.resendCount++;
          if(Controls.resendCount > 2){
            DateTime time1 = DateTime.now().add(const Duration(hours: 6));
            Controls.timeDuration = time1.toString();
            print('Hahha');
            await prefs.setString('timeDuration', time1.toString());
          }
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Code Sent"),
          ));
        }, codeAutoRetrievalTimeout: (String verificationId) {  }, verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {  },
      );
    }else{
      DateTime time1 = DateTime.parse(Controls.timeDuration);
      if(time1.compareTo(DateTime.now()).isNegative){
        print('Time has passed');
        Controls.timeDuration = "";
        Controls.resendCount = 0;
        await prefs.setString('timeDuration', "");
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: number,
          timeout: const Duration(seconds: 60),
          verificationFailed: (FirebaseAuthException e) {
            Constants.PopupDialog(context,"Code Not Sent");
          },
          codeSent: (String? verificationId, int? resendToken) async {
            vid = verificationId;
            Controls.resendCount++;
            if(Controls.resendCount > 2){
              DateTime time1 = DateTime.now().add(const Duration(hours: 6));
              Controls.timeDuration = time1.toString();
              await prefs.setString('timeDuration', time1.toString());
            }
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Code Sent"),
            ));
          }, codeAutoRetrievalTimeout: (String verificationId) {  }, verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {  },
        );
      }
      else{
        if(time1.difference(DateTime.now()).inHours > 0){
          Constants.PopupDialog(context,"You can resend code in " + time1.difference(DateTime.now()).inHours.toString() + " hours");
        }else{
          Constants.PopupDialog(context,"You can resend code in " + time1.difference(DateTime.now()).inMinutes.toString() + " minutes");
        }

      }
    }
  }

  CreateAccount(BuildContext context) {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
    client.RegisterAPI(
        '807620388065912',
        Controls.handle,
        number!,
        code!,
        "",
        Platform.isIOS ? '1' : '0',
        Controls.firebaseToken)
        .then((value) {
      Navigator.of(context).pop();
      if (value.code == "1") {
        Constants.ShowSnackBar(context, value.msg!);
        _resetCounter(value.UserId.toString());
        Controls.isfirst = true;
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => Settings_3_Page(),
          ), (route) =>
        false, //if you want to disable back feature set to false
        );
      } else {
        Constants.PopupDialog(context, value.msg!);
      }
    }, onError: (errorResponse) {
      Navigator.of(context).pop();
      Constants.PopupDialog(context,"Server Not Responding!");
    });
  }

  Future<void> _resetCounter(String newuserid) async {
    Controls.id = newuserid;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userid', newuserid);
    await prefs.setString('handle', Controls.handle);
  }

}