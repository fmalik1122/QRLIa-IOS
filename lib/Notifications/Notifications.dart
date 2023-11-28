import 'package:barcodeprinter/DataModers/NotificationsModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import '../SDP.dart';
import '../api/api_client.dart';
import '../utils/constants.dart';
import '../utils/controls.dart';


class Notifications extends StatefulWidget {
  const Notifications() : super();

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  List<Notificationslist> list = [];

  @override
  void initState() {
    super.initState();
    getNotfications(context);
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: const Color(0xFFFFFFFF),
        centerTitle: true,
        title: Text(
            'Notifications',
            style: TextDesigner(SDP.sdp(16), const Color(0xFFB492E8), 'b')
        ),
      ),
      body: Container(
        height: _size.height,
        width: _size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Login/bg.png"),
                fit: BoxFit.cover
            )
        ),
        child: Container(
          height: _size.height,
          width: _size.width,
          padding: EdgeInsets.only(top: SDP.sdp(15),left: SDP.sdp(8),right: SDP.sdp(8)),
          child: Column(
              children: [
                Expanded(
                    child:Stack(
                      children: [ list.isEmpty ? const Center(child: Text("There are no notifications to show")) : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: list.length,
                          itemBuilder: (context,index){
                            if(list[index].activitytype == "RequestReceived"){
                              return Container(
                                margin: EdgeInsets.all(SDP.sdp(5)),
                                width: _size.width-25,
                                height: SDP.sdp(40),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                        radius: SDP.sdp(15),
                                        backgroundImage: list[index].friendimage == "" ? NetworkImage("http://qrlia.com/core/public/appusers/qrliaface-icon.png") : NetworkImage(list[index].friendimage!)),
                                    Container(
                                      margin: EdgeInsets.only(left: SDP.sdp(10)),
                                      child: SizedBox(
                                        width: SDP.sdp(120),
                                        child: Text(
                                          list[index].friendname == "" ? "No Name" : list[index].friendname!,
                                          style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {},
                                      child: Container(
                                        height: SDP.sdp(20),
                                        width: SDP.sdp(50),
                                        decoration: BoxDecoration(
                                          border: const Border(
                                            bottom: BorderSide(width: 1.0, color:  Color(0xFFB492E8)),
                                            top: BorderSide(width: 1.0, color:  Color(0xFFB492E8)),
                                            right: BorderSide(width: 1.0, color:  Color(0xFFB492E8)),
                                            left: BorderSide(width: 1.0, color : Color(0xFFB492E8)),
                                          ),
                                          borderRadius: BorderRadius.circular(SDP.sdp(6)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Reject',
                                              style: TextDesigner(SDP.sdp(10), const Color(0xFFB492E8), 'r'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(left: SDP.sdp(10)),
                                        height: SDP.sdp(20),
                                        width: SDP.sdp(50),
                                        decoration: BoxDecoration(
                                          border: const Border(
                                            bottom: BorderSide(width: 1.0, color:  Color(0xFFB492E8)),
                                            top: BorderSide(width: 1.0, color:  Color(0xFFB492E8)),
                                            right: BorderSide(width: 1.0, color:  Color(0xFFB492E8)),
                                            left: BorderSide(width: 1.0, color : Color(0xFFB492E8)),
                                          ),
                                          borderRadius: BorderRadius.circular(SDP.sdp(6)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Accept',
                                              style: TextDesigner(SDP.sdp(10), const Color(0xFFB492E8), 'r'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }else{
                              return Container(
                                margin: EdgeInsets.all(SDP.sdp(5)),
                                width: _size.width-25,
                                height: SDP.sdp(40),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(backgroundImage: NetworkImage("http://qrlia.com/core/public/appusers/qrliaface-icon.png"), radius: SDP.sdp(15)),
                                    Container(
                                      margin: EdgeInsets.only(left: SDP.sdp(10)),
                                      child: SizedBox(
                                        width: SDP.sdp(190),
                                        child:
                                        Text(
                                          list[index].notificationmessage == "" ? "No Message" : list[index].notificationmessage!,
                                          style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                      ),
                      ],
                    )
                )
              ]
          ),
        ),
      ),
    );
  }

  Future<void> getNotfications(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if(isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.NotificationsAPI('807620388065912', Controls.id).then((value) {
        Navigator.of(context).pop();
        if (value.code == "1") {
          list = value.notificationslist;
          setState(() {});
        } else {
        }
      }, onError: (covariant) {
        Navigator.of(context).pop();
        Constants.PopupDialog(context, "Server Not Responding! " + covariant.toString());
      });
    }else{
      Constants.PopupDialog(context, "Check your internet Connection!");
    }
  }
}



