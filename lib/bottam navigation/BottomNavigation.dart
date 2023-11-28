import 'package:barcodeprinter/Profile/Settings.dart';
import 'package:barcodeprinter/Selfie/TakeSelfie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

import '../Friends/FriendsTab.dart';
import '../Notifications/Notifications.dart';
import '../Profile/ProfileTab.dart';
import '../Provider/business_provider.dart';
import '../SDP.dart';
import '../homepage.dart';
import '../utils/controls.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  Future<void> _isfirst() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first', false);
  }

  @override
  void initState() {
    super.initState();
    // Provider.of<FriendsProvider>(context, listen: false).getNotificationsCount();
    if(Controls.isfirst){
      Controls.bottomIndex = 3;
      _isfirst();
    }
  }

  final pages = [
    HomePage() ,
    FriendsLists(),
    Notifications(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    Size _size = MediaQuery
        .of(context)
        .size;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: pages[Controls.bottomIndex],
        bottomNavigationBar: Container(
            height: SDP.sdp(65),
            width: _size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Home/footer.png"),
                    fit: BoxFit.cover)
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: SDP.sdp(15),right: SDP.sdp(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Controls.bottomIndex = 3;
                            setState(() {

                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Controls.bottomIndex == 3 ?
                              Image(
                                image: Svg("assets/Home/Profile_p.svg", color: Color(0xFF6D6BDE)),
                                height: SDP.sdp(20),
                                width: SDP.sdp(20),
                              ) :
                              Image(
                                image: Svg("assets/Home/Profile.svg", color: Colors.black),
                                height: SDP.sdp(20),
                                width: SDP.sdp(20),
                              ),
                              Text('Profile',
                                style: TextDesigner(SDP.sdp(7), const Color(0xFF707070), 'r'),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Controls.bottomIndex = 1;
                            setState(() {});
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Controls.bottomIndex == 1 ?
                              Image(
                                image: Svg("assets/Home/friend_p.svg",color: Color(0xFF6D6BDE) ),
                                height: SDP.sdp(20),
                                width: SDP.sdp(20),
                              )
                                  :
                              Image(
                                image: Svg("assets/Home/friend.svg", color: Colors.black),
                                height: SDP.sdp(20),
                                width: SDP.sdp(20),
                              ),
                              Text(
                                'Friends',
                                style: TextDesigner(SDP.sdp(7), const Color(0xFF707070), 'r'),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              Controls.bottomIndex = 0;
                            });
                          },
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Controls.bottomIndex == 0 ?
                              Image(
                                image: Svg("assets/Home/Home_p.svg"),
                                height: SDP.sdp(20),
                                width: SDP.sdp(20),
                              )
                                  :
                              Image(
                                image: Svg("assets/Home/Home.svg"),
                                height: SDP.sdp(20),
                                width: SDP.sdp(20),
                              ),
                              Text('Home',
                                style: TextDesigner(SDP.sdp(7), const Color(0xFF707070), 'r'),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              Controls.bottomIndex = 2;
                            });
                          },
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Controls.bottomIndex == 2 ?
                                  Image(
                                    image: Svg("assets/Home/Notification_p.svg",color: Color(0xFF6D6BDE) ),
                                    height: SDP.sdp(20),
                                    width: SDP.sdp(20),
                                  )
                                      :
                                  Image(
                                    image: Svg("assets/Home/Notification.svg", color: Colors.black),
                                    height: SDP.sdp(20),
                                    width: SDP.sdp(20),
                                  ),
                                  Text('Notifications',
                                    style: TextDesigner(SDP.sdp(7), const Color(0xFF707070), 'r'),
                                  )
                                ],
                              ),
                              Consumer<FriendsProvider>(
                                builder: (context, val, child){
                                  return val.notiCount != "0" ? Positioned(
                                      top: SDP.sdp(8),
                                      right: SDP.sdp(5),
                                      child:
                                      GestureDetector(
                                        onTap: (){
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: Text(val.notiCount,
                                            style: TextDesigner(SDP.sdp(7), Colors.white, 'r'),),
                                          radius: SDP.sdp(8),),
                                      )
                                  ) : Container();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}