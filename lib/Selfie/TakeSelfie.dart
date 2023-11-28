import 'dart:convert';
import 'dart:io';
import 'package:barcodeprinter/Selfie/MakeComments.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:path/path.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

import '../SDP.dart';
import '../api/api_client.dart';
import '../utils/constants.dart';
import '../utils/controls.dart';

class TakeSelfie extends StatefulWidget {
  const TakeSelfie() : super();

  @override
  State<TakeSelfie> createState() => _TakeSelfieState();
}

class _TakeSelfieState extends State<TakeSelfie> {

  final String uploadUrl = 'http://qrlia.com/api/YesYesConnectUpdateProfileImage';
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  String address = "";

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    SDP.init(context);
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: const Color(0xFFFFFFFF),
        centerTitle: true,
        title: Text(
            'Take Selfie',
            style: TextDesigner(SDP.sdp(16), const Color(0xFFB492E8), 'b')
        ),
      ),
      body : Container(
        height: _size.height,
        width: _size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Login/bg.png"),
                fit: BoxFit.fitWidth
            )
        ),
        child: Container(
          height: _size.height,
          width: _size.width,
          padding: EdgeInsets.only(top: SDP.sdp(5),left: SDP.sdp(8),right: SDP.sdp(8)),
          child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: SDP.sdp(15), bottom: SDP.sdp(15)),
                  alignment: Alignment.center,
                  child: Image (
                      height: SDP.sdp(250),
                      width: SDP.sdp(250),
                      image: AssetImage("assets/Profile/Selfie Group.png")),
                ),
                Container(
                  margin: EdgeInsets.only(top: SDP.sdp(15)),
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () async {
                      try {
                        image = await _picker.pickImage(source: ImageSource.camera).then((value) {
                          Constants.Loading(context);
                          uploadSelfie(File(value!.path), context);
                          return value;
                        });
                      }
                      catch (e ){
                        Constants.ShowSnackBar(context, e.toString());
                      }
                    },
                    child: Container(
                      height: SDP.sdp(40),
                      width: SDP.sdp(120),
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
                              'Take Selfie',
                              style: TextDesigner(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: SDP.sdp(20)),
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                        return MakeComments();
                      }));
                    },
                    child: Container(
                      height: SDP.sdp(40),
                      width: SDP.sdp(120),
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
              ]
          ),
        ),
      ),
    );
  }

  Future uploadSelfie(File imageFile, BuildContext context) async {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse(uploadUrl);
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('userimage', stream, length,
        filename: basename(imageFile.path));
    request.files.add(multipartFile);
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      Navigator.pop(context);
      Map<String, dynamic> data = jsonDecode(value);
      if(data["code"] == "1")
      {
        Constants.ShowSnackBar(context, "Image Updated Successfully");
        Controls.selfie = data["imagename"];
        AddSelfie(context);
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {return MakeComments();}));
      } else {
        Constants.ShowSnackBar(context, "Error");}
    });
  }

  Future<void> AddSelfie(
      BuildContext context) async {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
    client.AddSelfie("807620388065912", Controls.connectionid, Controls.selfie).then((value) {
      Constants.ShowSnackBar(context, value.msg!);
      if (value.code == "1") {}
    }, onError: (covariant) {Constants.ShowSnackBar(context, "Server Not Responding!");});
  }
}
