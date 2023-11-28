import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Friend Profile/Friends ProfileTab.dart';
import '../Provider/business_provider.dart';
import '../SDP.dart';
import '../utils/constants.dart';
import '../utils/controls.dart';


class FriendsLists extends StatefulWidget {
  const FriendsLists() : super();
  @override
  State<FriendsLists> createState() => _FriendsListsState();
}

class _FriendsListsState extends State<FriendsLists> {
  @override
  void initState() {
    super.initState();
    Provider.of<FriendsProvider>(context, listen: false).getFriendsList(context);
    Provider.of<FriendsProvider>(context, listen: false).fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      appBar: AppBar(
        leading: null,
        backgroundColor: const Color(0xFFFFFFFF),
        centerTitle: true,
        title: Text('Connections', style: TextDesigner(SDP.sdp(16), const Color(0xFFB492E8), 'b')),
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
          padding: EdgeInsets.only(top: SDP.sdp(15), left: SDP.sdp(8), right: SDP.sdp(8)),
          child: SingleChildScrollView(
            child: Consumer<FriendsProvider>(
              builder: (context,val,child) {
                return Column(
                    children: [
                      Container(
                        width: _size.width - SDP.sdp(25),
                        height: SDP.sdp(30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(SDP.sdp(18)),
                          ),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: .5,
                                spreadRadius: .5),
                          ],
                        ),
                        child: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (value) {
                            Provider.of<FriendsProvider>(context,
                                listen: false)
                                .runFilter(value);
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: SDP.sdp(18), right: 0, top: 0, bottom: 0),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  SDP.sdp(18))),
                              borderSide: const BorderSide(
                                color: Color(0xFFAAACAE),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  SDP.sdp(18))),
                              borderSide: const BorderSide(
                                color: Color(0xFFAAACAE),
                                width: 1,
                              ),
                            ),
                            filled: true,
                            fillColor: Color(0xFFFFFFFF),
                            hintText: 'Search',
                            hintStyle: TextDesigner(
                                SDP.sdp(10), const Color(0xFFAAACAE), 'r'),
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SDP.sdp(10),
                      ),
                      Stack(
                        children: [
                          val.filteredlist.isEmpty
                              ? const Center(child: Text("No Connections, make new connection and view in list"))
                              : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: val.filteredlist.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
                                    if(isConnected){
                                      if (val.filteredlist[index].blockstatus == "1") {
                                        if (val.filteredlist[index]
                                            .blockedby ==
                                            val.filteredlist[index]
                                                .frienduserid) {
                                          Constants.ShowSnackBar(context,
                                              "Blocked by" +
                                                  val.filteredlist[index].friendname!);
                                        } else {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (BuildContext context) => FriendsProfile(fid : val.filteredlist[index].frienduserid.toString(), flist: val.list, canBack: true,)));
                                        }
                                      } else {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (BuildContext context) => FriendsProfile(fid : val.filteredlist[index].frienduserid.toString(),flist: val.list, canBack: true,)));
                                      }
                                    }else{
                                      Constants.PopupDialog(context, "Check your internet Connection!");
                                    }
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(SDP.sdp(5)),
                                    width: _size.width - 25,
                                    height: SDP.sdp(40),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: SDP.sdp(6)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        children: [
                                          CircleAvatar(
                                              backgroundImage: val
                                                  .filteredlist[index]
                                                  .friendimage == ""
                                                  ? const CachedNetworkImageProvider(
                                                  "http://qrlia.com/core/public/appusers/qrliaface-icon.png")
                                                  : CachedNetworkImageProvider(
                                                  val.filteredlist[index].friendimage!),
                                              radius: SDP.sdp(15)),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: SDP.sdp(10)),
                                            child: SizedBox(
                                              width: SDP.sdp(150),
                                              child:
                                              Text(
                                                val.filteredlist[index].friendname! == "" ? val.filteredlist[index].friendusername! : val.filteredlist[index].friendname! + " @" +
                                                    val.filteredlist[index]
                                                        .friendusername!,
                                                style: TextDesigner(
                                                    SDP.sdp(11),
                                                    const Color(0xFF1A1C2D),
                                                    'r'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SDP.sdp(15),
                      ),
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: SDP.sdp(15),
                            ),
                            Text('Invite Connections', style: TextDesigner(SDP.sdp(14), const Color(0xFF000000), 'r')),
                            SizedBox(
                              height: SDP.sdp(15),
                            ),
                            Consumer<FriendsProvider>(
                                builder: (context,val,child) {
                                  return Column(
                                      children: [
                                        Container(
                                          child: val.contacts!.isNotEmpty ? ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemCount: val.contacts?.length ?? 0,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  margin: EdgeInsets.all(SDP.sdp(5)),
                                                  width: SDP.sdp(200),
                                                  height: SDP.sdp(40),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(bottom: SDP.sdp(6)),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        CircleAvatar(
                                                          child: Text(
                                                              val.contacts![index].displayName.characters.first),
                                                          radius: SDP.sdp(15),),
                                                        Container(
                                                          width: SDP.sdp(170),
                                                          margin: EdgeInsets.only(left: SDP.sdp(10)),
                                                          child: SizedBox(
                                                            child: Text(
                                                              val.contacts![index].displayName,
                                                              style: TextDesigner(SDP.sdp(11),
                                                                  const Color(0xFF1A1C2D), 'r'),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            final fullContact = await FlutterContacts.getContact(val.contacts![index].id);
                                                            await launch('sms:' + fullContact!.phones.first.number + '&body=http://www.qrlia.com');
                                                          },
                                                          child: Container(
                                                            height: SDP.sdp(25),
                                                            width: SDP.sdp(60),
                                                            decoration: BoxDecoration(
                                                              border: const Border(
                                                                bottom: BorderSide(width: 1.0,
                                                                    color: Color(0xFF6D6BDE)),
                                                                top: BorderSide(width: 1.0,
                                                                    color: Color(0xFF6D6BDE)),
                                                                right: BorderSide(width: 1.0,
                                                                    color: Color(0xFF6D6BDE)),
                                                                left: BorderSide(width: 1.0,
                                                                    color: Color(0xFF6D6BDE)),
                                                              ),
                                                              borderRadius: BorderRadius.circular(
                                                                  SDP.sdp(6)),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .center,
                                                              children: [
                                                                Text(
                                                                  "Invite",
                                                                  style: TextDesigner(SDP.sdp(11),
                                                                      const Color(0xFF6D6BDE), 'r'),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                          ) : Container(),),
                                      ]
                                  );}),
                          ],
                        ),
                      )
                    ]
                );}),
          ),
        ),
      ),
    );
  }
}


