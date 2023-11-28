import 'package:barcodeprinter/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../DataModers/FrieList.dart';
import '../Friend Profile/Friends ProfileTab.dart';
import '../SDP.dart';
import '../api/api_client.dart';
import '../utils/controls.dart';

class MakeComments extends StatefulWidget {
  const MakeComments() : super();

  static const String ACCESS_TOKEN = "pk.eyJ1IjoiZmFoYWQxMTIyIiwiYSI6ImNsMzFsYncycjFibXQzY3Nid3hxNzl0ZnUifQ.LGtcPd8wPvPuqk6sh9XaGA";

  @override
  State<MakeComments> createState() => _MakeCommentsState();
}

class _MakeCommentsState extends State<MakeComments> {

  final String uploadUrl = 'http://mwsworkroom.com/YesYes/api/YesYesConnectUpdateProfileImage';
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  String comment = "";
  String address = "";
  var isLight = true;
  List<Friendslist> flist = [];

  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: const Color(0xFFFFFFFF),
        centerTitle: true,
        title: Text(
            'Make Comments', style: TextDesigner(SDP.sdp(16), const Color(0xFFB492E8), 'b')
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus;
        },
        child: Container(
          height: _size.height,
          width: _size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/Login/bg.png"), fit: BoxFit.cover)),
          padding: EdgeInsets.only(
              top: SDP.sdp(5), left: SDP.sdp(8), right: SDP.sdp(8)),
          child: SingleChildScrollView(
            child: Column(
                children: [
                  SizedBox(height: SDP.sdp(20)),
                  GestureDetector(
                    onTap: () async {},
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(children: [
                              Container(
                                height: SDP.sdp(80),
                                width: SDP.sdp(80),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: Controls.userimg == "" ? NetworkImage('http://qrlia.com/core/public/appusers/qrliaface-icon.png') : NetworkImage(Controls.userimg),
                                    ),
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                    BorderRadius.circular(SDP.sdp(10))),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: SDP.sdp(10)),
                                alignment: Alignment.center,
                                padding:
                                const EdgeInsets.only(left: 5.0, bottom: 5),
                                child: Text(
                                  "Name",
                                  style: TextDesigner(
                                      16, const Color(0xFF1A1C2D), 'r'),
                                ),
                              ),
                            ]),
                            Column(children: [
                              Container(
                                margin: EdgeInsets.only(left: SDP.sdp(20)),
                                height: SDP.sdp(80),
                                width: SDP.sdp(100),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: Controls.selfie == "" ? NetworkImage('http://qrlia.com/core/public/appusers/qrliaface-icon.png') : NetworkImage(Controls.baseurl + Controls.selfie),
                                        fit: BoxFit.cover),
                                    shape: BoxShape.rectangle,
                                    borderRadius:
                                    BorderRadius.circular(SDP.sdp(10))),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: SDP.sdp(10), left: SDP.sdp(20)),
                                alignment: Alignment.center,
                                padding:
                                const EdgeInsets.only(left: 5.0, bottom: 5),
                                child: Text(
                                  "Selfie",
                                  style: TextDesigner(
                                      16, const Color(0xFF1A1C2D), 'r'),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: SDP.sdp(50)),
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      'Note to your new connection',
                      style: TextDesigner(16, const Color(0xFF1A1C2D), 'r'),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SDP.sdp(8)),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(top: SDP.sdp(10), bottom: SDP.sdp(5)),
                    width: _size.width - 25,
                    height: SDP.sdp(135),
                    child: Padding(
                      padding:
                      EdgeInsets.only(left: SDP.sdp(10), right: SDP.sdp(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: SDP.sdp(20),
                                backgroundImage: Controls.business.userimage == "" ? NetworkImage('http://qrlia.com/core/public/appusers/qrliaface-icon.png') : NetworkImage(Controls.userimg),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: SDP.sdp(10)),
                                child:  SizedBox(
                                  height: SDP.sdp(20),
                                  width: SDP.sdp(180),
                                  child: TextField(
                                    maxLines: null,
                                    expands: true,
                                    onTap: (){
                                      setState(() {});
                                    },
                                    onChanged: (text){
                                      comment = text;
                                    },
                                    decoration: InputDecoration(
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFFA9A9A9)),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xFFA9A9A9)),
                                      ),
                                      filled: false,
                                      fillColor: const Color(0xFFF2F2F2),
                                      hintText: "Note to your new connection",
                                      hintStyle: TextDesigner(15.0,const Color(0xFFAAACAE),'m'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: SDP.sdp(15), right: SDP.sdp(15)),
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {return FriendsProfile(fid: Controls.connectionfid, flist: flist, canBack: false,);}));
                                  },
                                  child: Container(
                                    height: SDP.sdp(30),
                                    width: SDP.sdp(90),
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
                                            'Skip',
                                            style: TextDesigner(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: SDP.sdp(15), right: SDP.sdp(15)),
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    if(comment == ""){
                                      Constants.ShowSnackBar(context, "Comment Cannot Be Empty");
                                    }else{
                                      Constants.Loading(context);
                                      AddComment(context);
                                    }
                                  },
                                  child: Container(
                                    height: SDP.sdp(30),
                                    width: SDP.sdp(90),
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
                                            'Send',
                                            style: TextDesigner(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> AddComment(BuildContext context) async {
      final client = ApiClient(
        Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
    client.AddComment("807620388065912", Controls.connectionid, comment)
        .then((value) {
          Navigator.pop(context);
          Constants.ShowSnackBar(context, value.msg!);
          if (value.code == "1") {
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {return FriendsProfile(fid: Controls.connectionfid, flist: flist, canBack: false,);}));
          }
    }, onError: (covariant) {
      Constants.ShowSnackBar(context, "Server Not Responding!");
    });
  }

}
