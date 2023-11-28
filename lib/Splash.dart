import 'package:barcodeprinter/bottam%20navigation/BottomNavigation.dart';
import 'package:barcodeprinter/utils/constants.dart';
import 'package:barcodeprinter/utils/controls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../SDP.dart';
import 'Profile/Settings_1.dart';
import 'Provider/business_provider.dart';
import 'Selfie/SelectPinLocation.dart';
import 'Subscriptions/SubcriptionsPage.dart';
import 'api/api_client.dart';
import 'login/register.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen() : super();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 4), () async {
      _checkStatus();
    });
  }


  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    return Scaffold(
      body: Container(
        decoration:const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/Splash/bg.png"),
                fit:BoxFit.fill
            )
        ),

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Container(
                child: Image(image: AssetImage("assets/Splash/icon.png",
                ),
                  width: SDP.sdp(100),
                ),
              ),
            ],
        ),
          )
      ),
    );
  }

  Future<void> _checkStatus() async {
    // Provider.of<FriendsProvider>(context, listen: false).acquireCurrentLocation(context);
    final pref = await SharedPreferences.getInstance();
    Controls.id = pref.getString('userid') ?? "0";
    Controls.handle = pref.getString('handle') ?? "";
    Controls.timeDuration = pref.getString('timeDuration') ?? "";
    Controls.password = pref.getString('password') ?? " ";
    Controls.ispassword = pref.getBool('pass') ?? true;
    Controls.isfirst = pref.getBool('first') ?? true;
    Controls.userimg = pref.getString('userimage') ?? "";
    Controls.username = pref.getString('username') ?? "";
    Controls.QrTitle = pref.getString('qrtitle') ?? "";
    Controls.userphone = pref.getString('userphone') ?? "";
    if(Controls.ispassword && Controls.id != "0"){
      checkAccountStatus(context, Controls.id);
    }else{
      if(Controls.id != null || Controls.id != "0")
      {
        if(Controls.id == "0")
        {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => Signup()));
        }
        else if(Controls.id == null)
        {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => Signup()));
        }else{
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => BottomNavigation()));
        }
      }
    }
  }

  checkAccountStatus(BuildContext context, String id) {
    Constants.Loading(context);
    final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
    client.CheckUser('807620388065912', id).then((value) async {
      Navigator.of(context).pop();
      if (value.code == "1") {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Settings_1_Page()));
      }
      else {
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => Signup()));
      }
    }, onError: (errorResponse) {
      Navigator.of(context).pop();
      Constants.PopupDialog(context,"Server Not Responding!");
    });
  }

}
