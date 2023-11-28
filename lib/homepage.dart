
import 'dart:io';
import 'package:barcodeprinter/utils/constants.dart';
import 'package:barcodeprinter/utils/controls.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../SDP.dart';
import 'Selfie/SelectPinLocation.dart';
import 'api/api_client.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  const HomePage() : super();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String weblink = "http://qrlia.com/";
  String? vcardData, title;
  bool editable = false;

  @override
  void initState() {
    super.initState();
    print(Controls.id);
    vcardData = 'BEGIN:VCARD\n'
        'VERSION:3.0\n'
        'N:'+ Controls.username +';;;\n'
        'TEL;TYPE=CELL:'+ Controls.userphone +'\n'
        'END:VCARD';
  }

  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        title:  Text(
            'Home',
            style: TextDesigner(SDP.sdp(16), const Color(0xFFB492E8), 'b')
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/Login/bg.png'),
              fit: BoxFit.fill
            )
        ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: (){
                      scanQR(context);
                    },
                    child: Image (
                        height: SDP.sdp(100),
                        width: SDP.sdp(180),
                        image: AssetImage("assets/Splash/icon.png")),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !editable ? Container(
                        width: SDP.sdp(100),
                        child: Text(
                            Controls.QrTitle,
                            style: TextDesigner(SDP.sdp(20), const Color(0xFF000000), 'b')
                        ),
                      ): Container(
                        height: SDP.sdp(30),
                        width: SDP.sdp(100),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                          ),
                        ),
                        child: Form(
                          child: TextFormField(
                            style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                            textCapitalization: TextCapitalization.sentences,
                            onChanged: (val){
                              title = val;
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
                              hintText: "QR code title",
                              hintStyle: TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          editable = true;
                          setState(() {});
                        },
                        child: Positioned(
                            right: SDP.sdp(0),
                            child: !editable ? CircleAvatar(
                              backgroundColor: const Color(0xFFB492E8),
                              radius: SDP.sdp(8),
                              child: Icon(
                                Icons.edit,
                                size: SDP.sdp(8),
                                color: const Color(0xFFFFFFFF),
                              ),
                            ) : GestureDetector(
                              onTap: (){
                                setTitle(context);
                              },
                              child: Container(
                                height: SDP.sdp(20),
                                width: SDP.sdp(70),
                                margin: EdgeInsets.only(top: SDP.sdp(0)),
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
                                        'Done',
                                        style: TextDesigner(SDP.sdp(8), const Color(0xFFFFFFFF), 'r'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),),
                      ),
                    ]),
                SizedBox(
                  height: SDP.sdp(10),
                ),
                Container(
                  height: SDP.sdp(230),
                  child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),
                        child: Container(
                          height: SDP.sdp(30),
                          child: const TabBar(
                            unselectedLabelColor: Colors.black,
                            labelColor: Colors.white,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(color:  Color(0xFFB492E8)),
                            tabs: [
                              Tab(child :
                              Text("Link for QRLia users",),),
                              Tab(child: Text("Link for all other users",),),
                            ],
                          ),
                        ),
                      ), body: TabBarView(
                      children: [
                        Container(
                          margin: EdgeInsets.all(SDP.sdp(20)),
                          alignment: Alignment.center,
                          child: QrImage(
                            dataModuleStyle : const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Color(0xFFB492E8)
                            ),
                            eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: const Color(0xFFB492E8)
                            ),
                            data: weblink + Controls.handle,
                            errorCorrectionLevel: QrErrorCorrectLevel.H,
                            version: QrVersions.auto,
                            embeddedImage: AssetImage("assets/Home/qr_logo.png"),
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: Size.square(SDP.sdp(40)),
                            ),
                            size: SDP.sdp(150),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(SDP.sdp(20)),
                          alignment: Alignment.center,
                          child: QrImage(
                            dataModuleStyle : const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Color(0xFFB492E8)
                            ),
                            eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: const Color(0xFFB492E8)
                            ),
                            data: vcardData!,
                            errorCorrectionLevel: QrErrorCorrectLevel.H,
                            version: QrVersions.auto,
                            embeddedImage: AssetImage("assets/Home/qr_logo.png"),
                            embeddedImageStyle: QrEmbeddedImageStyle(
                              size: Size.square(SDP.sdp(40)),
                            ),
                            size: SDP.sdp(150),
                          ),
                        ),
                      ],
                    ),
                    ),
                  ),
                ),
                SizedBox(height: SDP.sdp(10),),
                Container(
                  child: Text(
                      'Tap on Scan button \n To Scan QR Code',
                      style: TextDesigner(SDP.sdp(13), const Color(0xFF000000), 'r')
                  ),
                ),
                SizedBox(height: SDP.sdp(30),),
                GestureDetector(
                  onTap: (){
                    scanQR(context);
                  },
                  child: Container(
                    height: SDP.sdp(45),
                    width: SDP.sdp(150),
                    margin: EdgeInsets.only(top: SDP.sdp(0)),
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
                            'Scan',
                            style: TextDesigner(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
             ),
          ),
        ),

    );
  }

  sendFriendRequestQr(BuildContext context, String fid, String meetingtime) {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
    client.FriendQr("807620388065912", Controls.id, fid, meetingtime).then((value){
      if(value.code == "1") {
        Navigator.of(context).pop();
        Constants.ShowSnackBar(context, value.msg.toString());
        Controls.connectionid = value.ConnectionId.toString();
        Controls.connectionfid = value.FriendId.toString();
        Controls.connectionname = fid;
        Controls.usertype = value.usertype!;
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {return const SelectPinLocation();}));
      }
      else {
        Navigator.of(context).pop();Constants.PopupDialog(context,value.msg.toString());
      }
    },
    onError: (covariant){
      Navigator.of(context).pop();
            Constants.PopupDialog(context,"Could not scan, try again");
    });
  }

  setTitle(BuildContext context) {
    Constants.Loading(context);
    final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
    client.SetQrTitle("807620388065912", Controls.id, title!).then((value) async {
      if(value.code == "1") {
        Navigator.of(context).pop();
        Controls.QrTitle = title!;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('qrtitle', title!);
        editable = false;
        setState(() {});
      }
      else {
        Navigator.of(context).pop();Constants.PopupDialog(context,value.msg.toString());
      }
    },
    onError: (covariant){
      Navigator.of(context).pop();
      Constants.PopupDialog(context,"Could not scan, try again");
    });
  }

  Future<void> scanQR(BuildContext context) async {
    String barcodeScanRes;
    String code;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
            Constants.Loading(context);
      code = barcodeScanRes.replaceAll(weblink, "");
      if(barcodeScanRes == "-1"){
        Navigator.of(context).pop();
              Constants.PopupDialog(context,"QR scan canceled");
      }else{
        var now = DateTime.now();
        var formatterDate = DateFormat('dd/MM/yy');
        var formatterTime = DateFormat('kk:mm');
        String actualDate = formatterDate.format(now);
        String actualTime = formatterTime.format(now);
        sendFriendRequestQr(context, code, actualDate + " " + actualTime );
      }

    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }
}

