import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../SDP.dart';
import 'controls.dart';



class Constants{

  static ShowSnackBar(BuildContext context, String _msg){
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
                Text(_msg,
                    style: TextDesigner_L(SDP.sdp(14),
                        const Color(0xFF1A1C2D), 'r')),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(150),
                    margin: EdgeInsets.only(top: SDP.sdp(30), bottom: SDP.sdp(10) ),
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
                            'Close',
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

  static Loading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const CupertinoAlertDialog(
          title: Center(child: CircularProgressIndicator(
            color: Color(0xFF747474),
          )),
          content: Text("Loading",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              color: Color(0xFF1C1C1C),
              fontSize: 14,
              fontFamily: 'DMSans',
            ),
          ),
        );
      },
    );
  }

  static PopupDialog(BuildContext context, String msg) {
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
            Text(msg, style: TextDesigner_L(SDP.sdp(14), const Color(0xFF1A1C2D), 'r')),
            GestureDetector(
              onTap: (){
                 Navigator.pop(context);
              },
              child: Container(
                height: SDP.sdp(30),
                width: SDP.sdp(150),
                margin: EdgeInsets.only(top: SDP.sdp(30), bottom: SDP.sdp(10) ),
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
                        'Close',
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

}