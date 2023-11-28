import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../DataModers/FrieList.dart';
import '../DataModers/NetworkListModel.dart';
import '../DataModers/profile.dart';
import '../SDP.dart';


TextDesigner(double _fSize, Color _fColor,String _fFamily){
  TextStyle _textStyle = TextStyle(
      fontSize: _fSize,
      color: _fColor,
      fontFamily: (_fFamily == 'R' || _fFamily == 'r') ? 'Poppins-Regular':(_fFamily == 'B' || _fFamily == 'b') ? 'Poppins-Bold':'Poppins-Medium'
  );
  return _textStyle;
}

TextDesigner_L(double _fSize, Color _fColor,String _fFamily){
  TextStyle _textStyle = TextStyle(
      fontSize: _fSize,
      color: _fColor,
      fontFamily: ('Lato-Regular_0')
  );
  return _textStyle;
}

class Controls{
  static String id = "";
  static String baseurl = 'http://qrlia.com/core/public/appusers/';
  static String username = "";
  static String userphone = "";
  static String QrTitle = "";
  static double brigtness = .3;
  static String userimg = "";
  static String countrtcode = "";
  static String userimgname = "";
  static String connectionid = "";
  static String connectionname = "";
  static String connectionfid = "";
  static String usertype = "";
  static String selfie = "";
  static String password = "";
  static bool ispassword = true;
  static bool isfirst = true ;
  static int bottomIndex = 0;
  static int resendCount = 0;
  static String timeDuration = "";
  static String firebaseToken = "";
  static int links = 3;
  static String handle = "";
  static Profile business = Profile();
  static List<NetworkslistModel> usernetworklist = [];
  static Friends friends = Friends(friendslist: []);
}



