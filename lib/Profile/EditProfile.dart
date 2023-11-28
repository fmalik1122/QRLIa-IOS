import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:barcodeprinter/DataModers/NetworkListModel.dart';
import 'package:barcodeprinter/DataModers/UserNetworkListModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:location/location.dart' as loc;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Provider/business_provider.dart';
import '../SDP.dart';
import '../api/api_client.dart';
import '../utils/constants.dart';
import '../utils/controls.dart';
import 'ProfileTab.dart';

class EditProfile extends StatefulWidget {

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> with WidgetsBindingObserver{
  bool _textFieldSelected = false;
  bool _editable = true;
  final Image _img = const Image(
    image: AssetImage('assets/profile/profile_image.png'),
  );
  final String uploadUrl = 'http://qrlia.com/api/YesYesConnectUpdateProfileImage';
  final String imgurl = "http://qrlia.com/core/public/appusers/";
  bool isSelected = false;
  String linkName = 'Zomato';
  final ImagePicker _picker = ImagePicker();
  File? image;
  Size? _size;
  List<NetworkslistModel> networks = [];
  List<TextEditingController> _controllers = [];
  List<TextEditingController> _titleControllers = [];
  List<GlobalKey<FormState>> _formKey = [];
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<FormState> usernameformkey = GlobalKey<FormState>();
  String? imagename;
  String title = "Title", url = "Url";
  bool erro =  false;
  bool virtualBusiness = false;
  loc.Location location = loc.Location();
  loc.LocationData? locationData;
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.4746,);
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  List<Marker> _markers = <Marker>[];
  String isvirtual = "0";
  var userNameFocusNode = FocusNode();
  String hnt = "Enter Url", accounttype = "User", userimage = "", handle = "", longitude = "", latitude = "", blongitude = "", blatitude = "";
  TextEditingController username = TextEditingController(), website = TextEditingController() , email = TextEditingController(),
   phone = TextEditingController(), baddress = TextEditingController(), cusaddress = TextEditingController(), qrtitle = TextEditingController(), empname = TextEditingController(),
   worktitle = TextEditingController(), workemail = TextEditingController(), btype = TextEditingController(),about = TextEditingController();

  final List<String> countryAreaCodes = ["+93", "+355", "+213",
    "+376", "+244", "+672", "+54", "+374", "+297", "+61", "+43", "+994", "+973",
    "+880", "+375", "+32", "+501", "+229", "+975", "+591", "+387", "+267", "+55",
    "+673", "+359", "+226", "+257", "+855", "+237", "+238", "+236",
    "+235", "+56", "+86","+57", "+269", "+242", "+682", "+506",
    "+385", "+53", "+357", "+420", "+45", "+253", "+593", "+20", "+503",
    "+240", "+291", "+372", "+251", "+500", "+298", "+679", "+358", "+33",
    "+689", "+241", "+220", "+995", "+49", "+233", "+350", "+30", "+299", "+502",
    "+224", "+245", "+592", "+509", "+504", "+852", "+36", "+91", "+62", "+98",
    "+964", "+353", "+972", "+39", "+225", "+1876", "+81", "+962",
    "+254", "+686", "+850", "+965", "+996", "+856", "+371", "+961", "+266", "+231",
    "+218", "+423", "+370", "+352", "+853", "+389", "+261", "+265", "+60",
    "+960", "+223", "+356", "+692", "+222", "+230", "+262", "+52", "+691",
    "+373", "+377", "+976", "+382", "+212", "+258", "+95", "+264", "+674", "+977",
    "+31", "+687", "+64", "+505", "+227", "+234", "+683", "+47", "+968",
    "+92", "+680", "+507", "+675", "+595", "+51", "+63", "+870", "+48", "+351",
    "+974", "+82", "+40", "+7", "+250", "+590", "+685", "+378", "+239", "+966",
    "+221", "+381", "+248", "+232", "+65", "+421", "+386", "+677", "+252", "+27",
    "+34", "+94", "+290", "+508", "+249", "+597", "+268", "+46", "+41",
    "+963", "+886", "+992", "+255", "+66", "+670", "+228", "+690", "+676", "+216", "+90",
    "+993", "+688", "+971", "+256", "+44", "+380", "+598", "+1", "+998", "+678",
    "+58", "+84", "+681", "+967", "+260", "+263"];

  final List<String> countryCodes = ["AF", "AL", "DZ", "AD", "AO",
    "AQ", "AR", "AM", "AW", "AU", "AT", "AZ", "BH", "BD", "BY", "BE",
    "BZ", "BJ", "BT", "BO", "BA", "BW", "BR", "BN", "BG", "BF",
    "BI", "KH", "CM", "CV", "CF", "TD", "CL", "CN",
    "CO", "KM", "CG", "CK", "CR", "HR", "CU", "CY", "CZ", "DK", "DJ",
    "EC", "EG", "SV", "GQ", "ER", "EE", "ET", "FK", "FO", "FJ",
    "FI", "FR", "PF", "GA", "GM", "GE", "DE", "GH", "GI", "GR", "GL",
    "GT", "GN", "GW", "GY", "HT", "HN", "HK", "HU", "IN", "ID", "IR",
    "IQ", "IE", "IM", "IL", "IT", "JM", "JP", "JO", "KE",
    "KI", "KP", "KW", "KG", "LA", "LV", "LB", "LS", "LR", "LY", "LI", "LT",
    "LU", "MO", "MK", "MG", "MW", "MY", "MV", "ML", "MT", "MH", "MR",
    "MU", "YT", "MX", "FM", "MD", "MC", "MN", "ME", "MA", "MZ", "MM", "NA",
    "NR", "NP", "NL", "NC", "NZ", "NI", "NE", "NG", "NU", "NO",
    "OM", "PK", "PW", "PA", "PG", "PY", "PE", "PH", "PN", "PL", "PT",
    "QA", "KR", "RO", "RU", "RW", "BL", "WS", "SM", "ST", "SA", "SN",
    "RS", "SC", "SL", "SG", "SK", "SI", "SB", "SO", "ZA", "ES",
    "LK", "SH", "PM", "SD", "SR", "SZ", "SE", "CH", "SY", "TW", "TJ",
    "TZ", "TH", "TL", "TG", "TK", "TO", "TN", "TR", "TM", "TV", "AE", "UG",
    "GB", "UA", "UY", "US", "UZ", "VU", "VE", "VN", "WF", "YE",
    "ZM", "ZW"
  ];

  final List<String> countryNames = ["Afghanistan", "Albania",
    "Algeria", "Andorra", "Angola", "Antarctica", "Argentina",
    "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan",
    "Bahrain", "Bangladesh", "Belarus", "Belgium", "Belize", "Benin",
    "Bhutan", "Bolivia", "Bosnia And Herzegovina", "Botswana",
    "Brazil", "Brunei Darussalam", "Bulgaria", "Burkina Faso",
    "Burundi", "Cambodia", "Cameroon",
    "Cape Verde", "Central African Republic", "Chad", "Chile", "China",
    "Colombia",
    "Comoros", "Congo", "Cook Islands", "Costa Rica", "Croatia",
    "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti",
    "Ecuador", "Egypt", "El Salvador",
    "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia",
    "Falkland Islands (malvinas)", "Faroe Islands", "Fiji", "Finland",
    "France", "French Polynesia", "Gabon", "Gambia", "Georgia",
    "Germany", "Ghana", "Gibraltar", "Greece", "Greenland",
    "Guatemala", "Guinea", "Guinea-bissau", "Guyana", "Haiti",
    "Honduras", "Hong Kong", "Hungary", "India", "Indonesia", "Iran",
    "Iraq", "Ireland", "Israel", "Italy", "Ivory Coast",
    "Jamaica", "Japan", "Jordan", "Kenya", "Kiribati", "Korea, Democratic People's",
    "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho",
    "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg",
    "Macao", "Macedonia", "Madagascar", "Malawi", "Malaysia",
    "Maldives", "Mali", "Malta", "Marshall Islands", "Mauritania",
    "Mauritius", "Mayotte", "Mexico", "Micronesia", "Moldova",
    "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar",
    "Namibia", "Nauru", "Nepal", "Netherlands", "New Caledonia",
    "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue",
    "Norway", "Oman", "Pakistan", "Palau", "Panama",
    "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn",
    "Poland", "Portugal", "Qatar", "Republic Of, Korea", "Romania",
    "Russian Federation", "Rwanda", "Saint Barthélemy", "Samoa",
    "San Marino", "Sao Tome And Principe", "Saudi Arabia", "Senegal",
    "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia",
    "Slovenia", "Solomon Islands", "Somalia", "South Africa",
    "Spain", "Sri Lanka", "Saint Helena",
    "Saint Pierre And Miquelon", "Sudan", "Suriname", "Swaziland",
    "Sweden", "Switzerland", "Syrian Arab Republic", "Taiwan",
    "Tajikistan", "Tanzania", "Thailand", "Timor-leste", "Togo", "Tokelau", "Tonga",
    "Tunisia", "Turkey", "Turkmenistan", "Tuvalu",
    "United Arab Emirates", "Uganda", "United Kingdom", "Ukraine",
    "Uruguay", "United States", "Uzbekistan", "Vanuatu",
    "Venezuela", "Viet Nam",
    "Wallis And Futuna", "Yemen", "Zambia", "Zimbabwe"];

  final List<String> countryFlags = ["assets/flags/_af.png" , "assets/flags/_al.png" , "assets/flags/_dz.png", "assets/flags/_ad.png", "assets/flags/_ao.png" ,
    "assets/flags/_aq.png", "assets/flags/_ar.png", "assets/flags/_am.png", "assets/flags/_aw.png", "assets/flags/_au.png", "assets/flags/_at.png", "assets/flags/_az.png", "assets/flags/_bh.png", "assets/flags/_bd.png", "assets/flags/_by.png", "assets/flags/_be.png",
    "assets/flags/_bz.png", "assets/flags/_bj.png", "assets/flags/_bt.png", "assets/flags/_bo.png", "assets/flags/_ba.png", "assets/flags/_bw.png", "assets/flags/_br.png", "assets/flags/_bn.png", "assets/flags/_bg.png", "assets/flags/_bf.png",
    "assets/flags/_bi.png", "assets/flags/_kh.png", "assets/flags/_cm.png", "assets/flags/_cv.png", "assets/flags/_cf.png", "assets/flags/_td.png", "assets/flags/_cl.png", "assets/flags/_cn.png",
    "assets/flags/_co.png", "assets/flags/_km.png", "assets/flags/_cg.png", "assets/flags/_ck.png", "assets/flags/_cr.png", "assets/flags/_hr.png", "assets/flags/_cu.png", "assets/flags/_cy.png", "assets/flags/_cz.png", "assets/flags/_dk.png", "assets/flags/_dj.png",
    "assets/flags/_ec.png", "assets/flags/_eg.png", "assets/flags/_sv.png", "assets/flags/_gq.png", "assets/flags/_er.png", "assets/flags/_ee.png", "assets/flags/_et.png", "assets/flags/_fk.png", "assets/flags/_fo.png", "assets/flags/_fj.png",
    "assets/flags/_fi.png", "assets/flags/_fr.png", "assets/flags/_pf.png", "assets/flags/_ga.png", "assets/flags/_gm.png", "assets/flags/_ge.png", "assets/flags/_de.png", "assets/flags/_gh.png", "assets/flags/_gi.png", "assets/flags/_gr.png", "assets/flags/_gl.png",
    "assets/flags/_gt.png", "assets/flags/_gn.png", "assets/flags/_gw.png", "assets/flags/_gy.png", "assets/flags/_ht.png", "assets/flags/_hn.png", "assets/flags/_hk.png", "assets/flags/_hu.png", "assets/flags/_in.png", "assets/flags/_id.png", "assets/flags/_ir.png",
    "assets/flags/_iq.png", "assets/flags/_ie.png", "assets/flags/_il.png", "assets/flags/_it.png", "assets/flags/_im.png", "assets/flags/_jm.png", "assets/flags/_jp.png", "assets/flags/_jo.png", "assets/flags/_ke.png",
    "assets/flags/_ki.png", "assets/flags/_kp.png", "assets/flags/_kw.png", "assets/flags/_kg.png", "assets/flags/_la.png", "assets/flags/_lv.png", "assets/flags/_lb.png", "assets/flags/_ls.png", "assets/flags/_lr.png", "assets/flags/_ly.png", "assets/flags/_li.png", "assets/flags/_lt.png",
    "assets/flags/_lu.png", "assets/flags/_mo.png", "assets/flags/_mk.png", "assets/flags/_mg.png", "assets/flags/_mw.png", "assets/flags/_my.png", "assets/flags/_mv.png", "assets/flags/_ml.png", "assets/flags/_mt.png", "assets/flags/_mh.png", "assets/flags/_mr.png",
    "assets/flags/_mu.png", "assets/flags/_yt.png", "assets/flags/_mx.png", "assets/flags/_fm.png", "assets/flags/_md.png", "assets/flags/_mc.png", "assets/flags/_mn.png", "assets/flags/_me.png", "assets/flags/_ma.png", "assets/flags/_mz.png", "assets/flags/_mm.png", "assets/flags/_na.png",
    "assets/flags/_nr.png", "assets/flags/_np.png", "assets/flags/_nl.png", "assets/flags/_nc.png", "assets/flags/_nz.png", "assets/flags/_ni.png", "assets/flags/_ne.png", "assets/flags/_ng.png", "assets/flags/_nu.png", "assets/flags/_no.png",
    "assets/flags/_om.png", "assets/flags/_pk.png", "assets/flags/_pw.png", "assets/flags/_pa.png", "assets/flags/_pg.png", "assets/flags/_py.png", "assets/flags/_pe.png", "assets/flags/_ph.png", "assets/flags/_pn.png", "assets/flags/_pl.png", "assets/flags/_pt.png",
    "assets/flags/_qa.png", "assets/flags/_kr.png", "assets/flags/_ro.png", "assets/flags/_ru.png", "assets/flags/_rw.png", "assets/flags/_bl.png", "assets/flags/_ws.png", "assets/flags/_sm.png", "assets/flags/_st.png", "assets/flags/_sa.png", "assets/flags/_sn.png",
    "assets/flags/_rs.png", "assets/flags/_sc.png", "assets/flags/_sl.png", "assets/flags/_sg.png", "assets/flags/_sk.png", "assets/flags/_si.png", "assets/flags/_sb.png", "assets/flags/_so.png", "assets/flags/_za.png", "assets/flags/_es.png",
    "assets/flags/_lk.png", "assets/flags/_th.png", "assets/flags/_pm.png", "assets/flags/_sd.png", "assets/flags/_sr.png", "assets/flags/_sz.png", "assets/flags/_se.png", "assets/flags/_ch.png", "assets/flags/_sy.png", "assets/flags/_tw.png", "assets/flags/_tj.png",
    "assets/flags/_tz.png", "assets/flags/_th.png", "assets/flags/_tl.png", "assets/flags/_tg.png", "assets/flags/_tk.png", "assets/flags/_to.png", "assets/flags/_tn.png", "assets/flags/_tr.png", "assets/flags/_tm.png", "assets/flags/_tv.png", "assets/flags/_ae.png", "assets/flags/_ug.png",
    "assets/flags/_uk.png", "assets/flags/_ua.png", "assets/flags/_uy.png", "assets/flags/_us.png", "assets/flags/_uz.png", "assets/flags/_vu.png", "assets/flags/_ve.png", "assets/flags/_vn.png", "assets/flags/_wf.png", "assets/flags/_ye.png",
    "assets/flags/_zm.png", "assets/flags/_zw.png",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Controls.isfirst = false;
    _getProfile(context);
    _getImageName();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      loc.PermissionStatus permissionGranted;
      permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.granted){
        _acquireCurrentLocation();
      }else{
        return null;
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    _size = MediaQuery.of(context).size;
    return Scaffold(
      drawerScrimColor: Colors.transparent,
      appBar: AppBar(
        leading: null,
        backgroundColor: const Color(0xFFFFFFFF),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        title: Text(username.text == "" ? handle : username.text,
            style: TextDesigner(SDP.sdp(16), const Color(0xFFB492E8), 'b')),
      ),
      body: Container(
        height: _size!.height,
        width: _size!.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Login/bg.png"), fit: BoxFit.cover)),
        padding: EdgeInsets.only(
            top: SDP.sdp(8), left: SDP.sdp(8), right: SDP.sdp(8)),
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: _size!.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (accounttype == "Business") Container(
                      alignment: Alignment.centerRight,
                      height: SDP.sdp(20),
                      child: Row(
                        children: [
                          Text("Virtual Business",
                              style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r')),
                          Checkbox(
                            side: BorderSide(width: .5,),
                            onChanged: (v){
                              if(_editable){
                                if(v!){
                                  isvirtual = "1";
                                }else{
                                  isvirtual = "0";
                                }
                                virtualBusiness = v;
                                setState(() {});
                              }
                            },
                            value: virtualBusiness,
                            activeColor: const Color(0xFFB492E8),
                          ),
                        ],
                      )
                  ) else Container(),
                  Container(
                      alignment: Alignment.centerRight,
                      height: SDP.sdp(20),
                      child: Row(
                        children: [
                          Text("Business",
                              style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r')),
                          Checkbox(
                            side: BorderSide(width: .5,),
                            onChanged: (v){
                              if(_editable){
                                if (v!) {
                                  showMaterialModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(SDP.sdp(0)),
                                      ),
                                      context: context,
                                      builder: (context) => Container(
                                        height: SDP.sdp(200),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Icon(
                                                Icons.warning_amber_rounded,
                                                size: SDP.sdp(40),
                                                color: const Color(0xFFB492E8),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: SDP.sdp(5), right: SDP.sdp(5)),
                                                child: Text("Phone number will be turned to 'Yes' for business users unless turned off",
                                                    textAlign: TextAlign.center,
                                                    style: TextDesigner_L(SDP.sdp(14),
                                                        const Color(0xFF1A1C2D), 'r')),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: (){
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      height: SDP.sdp(30),
                                                      width: SDP.sdp(100),
                                                      margin: EdgeInsets.only(top: SDP.sdp(30), bottom: SDP.sdp(10), right: SDP.sdp(10)),
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
                                                              'No',
                                                              style: TextDesigner_L(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      Navigator.pop(context);
                                                      accounttype = "Business";
                                                      isSelected = v;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      height: SDP.sdp(30),
                                                      width: SDP.sdp(100),
                                                      margin: EdgeInsets.only(top: SDP.sdp(30), bottom: SDP.sdp(10)),
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
                                                              'Yes',
                                                              style: TextDesigner_L(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  );
                                } else {
                                  accounttype = "User";
                                  isSelected = v;
                                  setState(() {});
                                }
                              }
                            },
                            value: isSelected,
                            activeColor: const Color(0xFFB492E8),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                if(_editable){
                  try {
                      image = await _picker.pickImage(source: ImageSource.gallery).then((value) {
                      uploadImage(File(value!.path), context);
                    });
                  } catch (e) {
                          Constants.PopupDialog(
                            context, "No Image Selected!");
                  }
                }
              },
              child: Column(
                children: [
                  Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: SDP.sdp(80),
                          width: SDP.sdp(80),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: userimage == ""
                                    ? NetworkImage(
                                        "http://qrlia.com/core/public/appusers/qrliaface-icon.png")
                                    : NetworkImage(userimage),
                              ),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(SDP.sdp(10))),
                        ),
                        _editable ? Positioned(
                            bottom: SDP.sdp(0),
                            right: SDP.sdp(0),
                            child: CircleAvatar(
                              backgroundColor: const Color(0xFFB492E8),
                              radius: SDP.sdp(10),
                              child: Icon(
                                Icons.edit,
                                size: SDP.sdp(10),
                                color: const Color(0xFFFFFFFF),
                              ),
                            )) : Container(),
                  ]),
                  Container(
                    margin: EdgeInsets.only(top: SDP.sdp(2)),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      username.text + "@" + handle,
                      style: TextDesigner(
                          SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 5.0, bottom: 5),
                    child: Text(
                      email.text,
                      style: TextDesigner(
                          SDP.sdp(10), const Color(0xFFA9A9A9), 'r'),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                  width: _size!.width - SDP.sdp(25),
                  height: SDP.sdp(30),
                  child: Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(100),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                      ),
                    ),
                    child: Form(
                      key: usernameformkey,
                      child: TextFormField(
                        controller: username,
                        focusNode: userNameFocusNode,
                        style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                        textCapitalization: TextCapitalization.sentences,
                        enabled: _editable ? true : false,
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Name field cannot be empty";
                          }else{
                            return null;
                          }
                        },
                        onChanged: (v) {
                          usernameformkey.currentState!.validate();
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
                          hintText: "Name",
                          hintStyle: TextDesigner(
                              SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                        ),
                      ),
                    ),
                  ),
                ),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
              child: Container(
                height: SDP.sdp(30),
                width: SDP.sdp(100),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Consumer<FriendsProvider>(
                      builder: (context, val, child){
                        return GestureDetector(
                          onTap: (){
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) => CountryDialog(context));
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: SDP.sdp(10)),
                            height: SDP.sdp(25),
                            width: SDP.sdp(25),
                            child: Image(image : AssetImage(val.cflag)),
                          ),
                        );
                      },
                    ),
                    Consumer<FriendsProvider>(
                      builder: (context, val, child){
                        return Container(
                          height: SDP.sdp(25),
                          width: SDP.sdp(45),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(width: 1.0, color: Colors.grey[300]!),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: (){
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) => CountryDialog(context));
                            },
                            child: Center(
                              child: TextFormField(
                                textCapitalization: TextCapitalization.sentences,
                                enabled: false,
                                style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                                decoration: InputDecoration(
                                  isCollapsed: true,
                                  isDense: true,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left : SDP.sdp(10), top: SDP.sdp(3), bottom:  SDP.sdp(3)),
                                  hintText: val.ccode,
                                  hintStyle: TextDesigner(
                                      SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                                ),
                                obscureText: false,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      height: SDP.sdp(30),
                      width: SDP.sdp(180) ,
                      child: Center(
                        child: TextField(
                          controller: phone,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                          decoration: InputDecoration(
                            isCollapsed: true,
                            isDense: true,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(left : SDP.sdp(10), bottom:  SDP.sdp(3), top:  SDP.sdp(3)),
                            hintText: '123456789',
                            hintStyle: TextDesigner(
                                SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                          ),
                          obscureText: false,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: empname,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
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
                        hintText:  accounttype == "Business" ? "Business name" : "Employer or Business or School name",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (accounttype == "Business" && !virtualBusiness) Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: SDP.sdp(30),
                      width: SDP.sdp(250),
                      alignment: Alignment.centerLeft,
                      child:
                      GooglePlaceAutoCompleteTextField(
                          textEditingController: baddress,
                          googleAPIKey: "AIzaSyAo2CVPirJe02wbOmVOapIRXJkR4Qmrqks",
                          inputDecoration: InputDecoration(
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
                            hintText: "Business Address",
                            hintStyle: TextDesigner(
                                SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                          ),
                          debounceTime: 800,
                          isLatLngRequired: true,
                          getPlaceDetailWithLatLng: (Prediction prediction) async {
                            _markers.clear();
                            List<Placemark> placemarks = await placemarkFromCoordinates(double.tryParse(prediction.lat!)!, double.tryParse(prediction.lng!)!);
                            Placemark place = placemarks[0];
                            baddress.text = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
                            GoogleMapController controller = await _controller.future;
                            controller.animateCamera(CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: LatLng(double.tryParse(prediction.lat!)!, double.tryParse(prediction.lng!)!),
                                  tilt: 59.440717697143555,
                                  zoom: 19.151926040649414,
                                )
                            ));
                            _markers.add(
                                Marker(
                                    markerId: const MarkerId('BID'),
                                    draggable: true,
                                    position: LatLng(double.tryParse(prediction.lat!)!, double.tryParse(prediction.lng!)!),
                                    infoWindow: const InfoWindow(
                                        snippet: 'Long press to move marker',
                                        title: 'Business Location'
                                    ),
                                    onDragEnd: ((newPosition) async {
                                      List<Placemark> placemarks = await placemarkFromCoordinates(newPosition.latitude, newPosition.longitude);
                                      Placemark place = placemarks[0];
                                      baddress.text = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}';
                                    }
                                    ))
                            );
                            setState(() {});
                          },
                          itmClick: (Prediction prediction) async {
                            baddress.text = prediction.description!;
                            baddress.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description!.length));}
                        // default 600 ms ,
                      )
                  ),
                ],
              ),
            ) else Container(),
            if (accounttype == "Business" && !virtualBusiness) Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(50),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(50),
                    width: SDP.sdp(250),
                    margin: EdgeInsets.only(top: SDP.sdp(5)),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      maxLines: null,
                      expands: true,
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                      controller: cusaddress,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
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
                        hintText: "Businsee Address (Custom)",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ) else Container(),
            if (accounttype == "Business" && !virtualBusiness) Container(
                margin: EdgeInsets.only(top: SDP.sdp(5), bottom: SDP.sdp(5)),
                height: SDP.sdp(140),
                width: _size!.width,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(SDP.sdp(20))),
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  myLocationEnabled: true,
                  markers: Set<Marker>.of(_markers),
                  gestureRecognizers: {
                    Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
                  },
                  onMapCreated: (GoogleMapController controller) {
                    if(!_controller.isCompleted){
                      _controller.complete(controller);
                    }
                    _acquireCurrentLocation();
                  },
                )) else Container(),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: worktitle,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
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
                        hintText: accounttype == "Business" ? "Title at Business" : "Title at work or school",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: workemail,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
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
                        hintText: "Work or school or other email",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            accounttype == "Business" ? Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                      controller: btype,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
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
                        hintText: "Business Type",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ) : Container(),
            accounttype == "Business" ? Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: website,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: _editable ? true : false,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
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
                        hintText: "Website",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ) : Container(),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(30),
              child: Container(
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
                    controller: qrtitle,
                    style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                    textCapitalization: TextCapitalization.sentences,
                    enabled: _editable ? true : false,
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
                      hintStyle: TextDesigner(
                          SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: _size!.width - SDP.sdp(25),
              height: SDP.sdp(60),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: SDP.sdp(50),
                    width: SDP.sdp(250),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: about,
                      maxLines: null,
                      expands: true,
                      style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                      textCapitalization: TextCapitalization.sentences,
                      enabled: true,
                      onTap: () {
                        _textFieldSelected = false;
                        setState(() {});
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
                        hintMaxLines: 2,
                        fillColor: const Color(0xFFF2F2F2),
                        hintText: "About - Add a few lines about yourself, personal interests, professional experience and achievements",
                        hintStyle: TextDesigner(
                            SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ],
              ),
            ) ,
            DynamicUserNetworkList(),
            SizedBox(height: SDP.sdp(10),),
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();
                _getNetworkList(context);
              },
              child: Text("Add OTHER social networks and CUSTOM links",
                  style: TextDesigner(SDP.sdp(10), const Color(0xFFB492E8), 'r')),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              FocusManager.instance.primaryFocus!.unfocus();
              _getNetworkList(context);
            },
            child: Container(
              height: SDP.sdp(40),
              width: SDP.sdp(130),
              margin: EdgeInsets.only(top: SDP.sdp(10), bottom: SDP.sdp(20)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SDP.sdp(15)),
                color: const Color(0xFFB492E8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add OTHER social \n networks',
                    textAlign: TextAlign.center,
                    style: TextDesigner(
                        SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              FocusManager.instance.primaryFocus!.unfocus();
              if(phone.text.isNotEmpty){
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext diagContext) => CountryCodeConfirmationDialog(diagContext));
              }else{
                FocusManager.instance.primaryFocus!.unfocus();
                bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
                if (isConnected == true) {
                  if(username.text.isEmpty){
                     usernameformkey.currentState!.validate();
                     userNameFocusNode.requestFocus();
                  }else{
                    if (!(accounttype == "User") && !virtualBusiness) {
                      if(baddress.text != ""){
                        LatLng latLng = _markers.first.position;
                        blatitude = latLng.latitude.toString();
                        blongitude = latLng.longitude.toString();
                      }
                    }
                    UpdateProfile(context);
                    updateUserNetworkList(context);
                  }
                } else {
                  Constants.ShowSnackBar(
                      context, "Check your internet Connection!");
                }
              }
            },
            child: Container(
              height: SDP.sdp(40),
              width: SDP.sdp(130),
              margin: EdgeInsets.only(top: SDP.sdp(10), bottom: SDP.sdp(20), left: SDP.sdp(10)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SDP.sdp(15)),
                color: const Color(0xFFB492E8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Save Changes',
                    style: TextDesigner(
                        SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget DynamicUserNetworkList() {
    return SizedBox(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: Controls.usernetworklist.length,
        itemBuilder: (BuildContext context, index) {
          _controllers.add(TextEditingController());
          _titleControllers.add(TextEditingController());
          _formKey.add(GlobalKey<FormState>());
          _controllers[index].text = Controls.usernetworklist[index].networkvalue!;
          _titleControllers[index].text = Controls.usernetworklist[index].networkname!;
          Provider.of<FriendsProvider>(context, listen: false).UrlValidateValues(false);
          if(Controls.usernetworklist[index].networkformat == "handle"){
            return Padding(
              padding: EdgeInsets.only( left:  SDP.sdp(5)),
              child: Stack(
                children: [
                  Consumer<FriendsProvider>(
                    builder: (context, val, child){
                      return Container(
                        height: SDP.sdp(50),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                            BorderSide(width: 1.0, color: val.onError[index] ? Colors.red : Colors.grey[300]!),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: SDP.sdp(15),
                              backgroundImage:
                              Controls.usernetworklist[index].networkicon == ""
                                  ? NetworkImage(
                                  'http://qrlia.com/core/public/appusers/qrliaface-icon.png')
                                  : NetworkImage(
                                  Controls.usernetworklist[index].networkicon!),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: SDP.sdp(5)),
                                  child: Container(
                                    width: _size!.width - SDP.sdp(60),
                                    child: TextField(
                                      enabled: false,
                                      controller: _titleControllers[index],
                                      textAlignVertical: TextAlignVertical.bottom,
                                      onTap: () {
                                        _textFieldSelected = false;
                                        setState(() {});
                                      },
                                      onChanged: (text) {
                                        Controls.usernetworklist[index].networkvalue = text;
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        isCollapsed: true,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        filled: false,
                                        fillColor: const Color(0xFFAAACAE),
                                        hintText: Controls.usernetworklist[index].networkname,
                                        hintStyle: TextDesigner(
                                            SDP.sdp(11), const Color(0xFF000000), 'r'),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: SDP.sdp(5)),
                                  child: Container(
                                    width: _size!.width - SDP.sdp(60),
                                    child: Form(
                                      key: _formKey[index],
                                      child: TextFormField(
                                        style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                                        textCapitalization: TextCapitalization.sentences,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[a-zA-Z0-9\$#._@]")),
                                        ],
                                        enabled: _editable ? true : false,
                                        controller: _controllers[index],
                                        textAlignVertical: TextAlignVertical.bottom,
                                        onChanged: (text) {
                                          Controls.usernetworklist[index].networkvalue = text;
                                        },
                                        decoration: InputDecoration(
                                          isDense: true,
                                          isCollapsed: true,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(vertical: SDP.sdp(3)),
                                          fillColor: const Color(0xFFAAACAE),
                                          hintText: "Enter Handle",
                                          hintStyle: TextDesigner(
                                              SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 0,
                    top: 5,
                    child: InkWell(
                      onTap: () {
                        if (Controls.usernetworklist.length > 0) {
                          Controls.usernetworklist.removeAt(index);
                          _controllers[index].clear();
                          _controllers.removeAt(index);
                          _titleControllers[index].clear();
                          _titleControllers.removeAt(index);
                          setState(() {});
                        } else {}
                        setState(() {});
                      },
                      child: CircleAvatar(
                        radius: SDP.sdp(8),
                        backgroundColor:
                        const Color(0xFFB492E8),
                        child: Icon(
                          Icons.clear,
                          size: SDP.sdp(10),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          else if(Controls.usernetworklist[index].networkformat == "url"){
            return Padding(
              padding: EdgeInsets.only( left:  SDP.sdp(5)),
              child: Stack(
                children: [
                  Consumer<FriendsProvider>(
                    builder: (context, val, child){
                      return Container(
                        height: SDP.sdp(50),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                            BorderSide(width: 1.0, color: val.onError[index] ? Colors.red : Colors.grey[300]!),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: SDP.sdp(15),
                              backgroundImage:
                              Controls.usernetworklist[index].networkicon == "" ? NetworkImage(
                                  'http://qrlia.com/core/public/appusers/qrliaface-icon.png') : NetworkImage(
                                  Controls.usernetworklist[index].networkicon!),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: SDP.sdp(5)),
                                      child: Container(
                                        width: Controls.usernetworklist[index].networktype == "custom" ? _size!.width - SDP.sdp(60) :  SDP.sdp(60) ,
                                        child: TextField(
                                          enabled: Controls.usernetworklist[index].networktype == "custom" ? true : false,
                                          textAlignVertical: TextAlignVertical.bottom,
                                          controller: _titleControllers[index],
                                          onChanged: (text) {
                                            Controls.usernetworklist[index].networkname = text;
                                          },
                                          decoration: InputDecoration(
                                            isDense: true,
                                            isCollapsed: true,
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            filled: false,
                                            contentPadding: EdgeInsets.symmetric(vertical: SDP.sdp(3)),
                                            fillColor: const Color(0xFFAAACAE),
                                            hintText: Controls.usernetworklist[index].networkname,
                                            hintStyle: TextDesigner(
                                                SDP.sdp(11), const Color(0xFF000000), 'r'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if(Controls.usernetworklist[index].networktype != "custom") InkWell(
                                      onTap: () async {
                                        var url = "https://youtu.be/WR1AteRkZlA";
                                        await launch(url);
                                      },
                                      child: Text(
                                          '3 steps process to add your Linkedin URL',
                                          style: TextDesigner(SDP.sdp(8),const Color(0xFFB492E8),'r')
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: SDP.sdp(5)),
                                  child: Container(
                                    width: _size!.width - SDP.sdp(60),
                                    child: Form(
                                      key: _formKey[index],
                                      child: TextFormField(
                                        style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                                        textCapitalization: TextCapitalization.sentences,
                                        enabled: _editable ? true : false,
                                        controller: _controllers[index],
                                        textAlignVertical: TextAlignVertical.bottom,
                                        onChanged: (text) {
                                          Controls.usernetworklist[index].networkvalue = text;
                                        },
                                        decoration: InputDecoration(
                                          isDense: true,
                                          isCollapsed: true,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          filled: false,
                                          fillColor: const Color(0xFFAAACAE),
                                          hintText: "Enter URL",
                                          hintStyle: TextDesigner(
                                              SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 0,
                    top: 5,
                    child: InkWell(
                      onTap: () {
                        if (Controls.usernetworklist.length > 0) {
                          Controls.usernetworklist.removeAt(index);
                          _controllers[index].clear();
                          _controllers.removeAt(index);
                          _titleControllers[index].clear();
                          _titleControllers.removeAt(index);
                          setState(() {});
                        } else {}
                        setState(() {});
                      },
                      child: CircleAvatar(
                        radius: SDP.sdp(8),
                        backgroundColor:
                        const Color(0xFFB492E8),
                        child: Icon(
                          Icons.clear,
                          size: SDP.sdp(10),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }else{
            return Padding(
              padding: EdgeInsets.only( left:  SDP.sdp(5)),
              child: Stack(
                children: [
                  Consumer<FriendsProvider>(
                    builder: (context, val, child){
                      return Container(
                        height: SDP.sdp(50),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom:
                            BorderSide(width: 1.0, color: val.onError[index] ? Colors.red : Colors.grey[300]!),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: SDP.sdp(15),
                              backgroundImage:
                              Controls.usernetworklist[index].networkicon == ""
                                  ? NetworkImage(
                                  'http://qrlia.com/core/public/appusers/qrliaface-icon.png')
                                  : NetworkImage(
                                  Controls.usernetworklist[index].networkicon!),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: SDP.sdp(5)),
                                  child: Container(
                                    width: _size!.width - SDP.sdp(60),
                                    child: TextField(
                                      enabled: false,
                                      textAlignVertical: TextAlignVertical.bottom,
                                      controller: _titleControllers[index],
                                      onTap: () {
                                        _textFieldSelected = false;
                                        setState(() {});
                                      },
                                      onChanged: (text) {
                                        Controls.usernetworklist[index].networkvalue = text;
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        isCollapsed: true,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        filled: false,
                                        contentPadding: EdgeInsets.symmetric(vertical: SDP.sdp(3)),
                                        fillColor: const Color(0xFFAAACAE),
                                        hintText: Controls.usernetworklist[index].networkname,
                                        hintStyle: TextDesigner(
                                            SDP.sdp(11), const Color(0xFF000000), 'r'),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: SDP.sdp(5)),
                                  child: Container(
                                    width: _size!.width - SDP.sdp(60),
                                    child: Form(
                                      key: _formKey[index],
                                      child: TextFormField(
                                        style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                                        textCapitalization: TextCapitalization.sentences,
                                        enabled: _editable ? true : false,
                                        controller: _controllers[index],
                                        textAlignVertical: TextAlignVertical.bottom,
                                        onChanged: (text) {
                                          Controls.usernetworklist[index].networkvalue = text;
                                        },
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          isCollapsed: true,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          filled: false,
                                          fillColor: const Color(0xFFAAACAE),
                                          hintText: "Enter Number",
                                          hintStyle: TextDesigner(
                                              SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 0,
                    top: 5,
                    child: InkWell(
                      onTap: () {
                        if (Controls.usernetworklist.length > 0) {
                          Controls.usernetworklist.removeAt(index);
                          _controllers[index].clear();
                          _controllers.removeAt(index);
                          _titleControllers[index].clear();
                          _titleControllers.removeAt(index);
                          setState(() {});
                        } else {}
                        setState(() {});
                      },
                      child: CircleAvatar(
                        radius: SDP.sdp(8),
                        backgroundColor:
                        const Color(0xFFB492E8),
                        child: Icon(
                          Icons.clear,
                          size: SDP.sdp(10),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  UpdateProfile(BuildContext context) {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
    Constants.Loading(context);
    client.UpdateProfileAPI(
            "807620388065912",
            Controls.id,
            username.text,
            qrtitle.text,
            imagename!,
            accounttype,
            baddress.text,
            cusaddress.text,
            blongitude,
            blatitude,
            btype.text,
            empname.text,
            worktitle.text,
            workemail.text,
            website.text,
            phone.text,
            Provider.of<FriendsProvider>(context, listen: false).ccode,
            isvirtual,
            email.text,
            about.text)
        .then((value) {
      Navigator.of(context).pop();
      if (value.code == "1") {
        Constants.ShowSnackBar(context, value.msg!);
        _resetCounter();
      } else {
        Constants.PopupDialog(context, value.msg!);
      }
    }, onError: (covariant) {
      Navigator.of(context).pop();
      Constants.PopupDialog(context, "Server Not Responding!");
    });
  }

  updateUserNetworkList(BuildContext context) async {
    UserNetworksListModel body = UserNetworksListModel(networkslist: [], usernetworkslist: []);
    body.userid = Controls.id;
    body.msg = "";
    body.code = "";
    body.networkslist = Controls.usernetworklist;
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      final client =
      ApiClient(Dio(BaseOptions(contentType: "application/json")));
      client.UpdateUserNetworkListAPI("807620388065912", body).then((value) {
      }, onError: (covariant) {});
    } else {}
  }

  Future uploadImage(File imageFile, BuildContext context) async {
    Constants.Loading(context);
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse(uploadUrl);
    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('userimage', stream, length,
        filename: Path.basename(imageFile.path));
    request.files.add(multipartFile);
    var response = await request.send();
    response.stream.transform(utf8.decoder).listen((value) {
      Navigator.pop(context);
      print("hello" + value.toString());
      Map<String, dynamic> data = jsonDecode(value);
      if (data["code"] == "1") {
        setState(() {
          imagename = data["imagename"];
          userimage = imgurl + imagename!;
        });
      } else {
        Constants.ShowSnackBar(context, data["msg"]);
      }
    }, onError: (covariant) {
      Navigator.pop(context);
      Constants.PopupDialog(
              context, "Server Not Responding!" + covariant.toString());
    });
  }

   _getProfile(BuildContext context) async {
     username.text = Controls.business.name!;
     handle = Controls.business.username!;
     userimage = Controls.business.userimage!;
     qrtitle.text = Controls.business.qrtitle!;
     accounttype = Controls.business.accounttype!;
     empname.text = Controls.business.workbusinessname!;
     website.text = Controls.business.website!;
     phone.text = Controls.business.phone!;
     worktitle.text = Controls.business.worktitle!;
     email.text = Controls.business.email!;
     workemail.text = Controls.business.workemail!;
     btype.text = Controls.business.businesstype!;
     baddress.text = Controls.business.businessaddress!;
     cusaddress.text = Controls.business.cusaddress!;
     blatitude = Controls.business.businesslatitude!;
     blongitude = Controls.business.businesslongitude!;
     about.text = Controls.business.about!;
     if (accounttype == "User") {
       isSelected = false;
     } else {
       isSelected = true;
     }
     if (isvirtual == "0") {
       virtualBusiness = false;
     } else {
       virtualBusiness = true;
     }
  }

  Future<void> _getNetworkList(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.AllNetworkList("807620388065912", Controls.id).then((value) {
        Navigator.of(context).pop();
        if (value.code == "1") {
          networks = value.networkslist;
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                    builder: (context, StateSetter setState) {
                      return NetworksDialog(context, networks);
                    }
                );
              });
        }
      }, onError: (covariant) {
        Navigator.of(context).pop();
        Constants.PopupDialog(context, "Server Not Responding!" + covariant.toString());
      });
    } else {}
  }

  Future<void> _resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    Controls.userimg = userimage;
    Controls.userimgname = imagename!;
    Controls.username = username.text;
    Controls.QrTitle = qrtitle.text;
    Controls.userphone = Provider.of<FriendsProvider>(context, listen: false).ccode + phone.text;
    await prefs.setString('userimage', userimage);
    await prefs.setString('qrtitle', qrtitle.text);
    await prefs.setString('userimgname', imagename!);
    await prefs.setString('username', username.text);
    await prefs.setString('userphone', Controls.userphone);
  }

  Future<void> _getImageName() async {
    final pref = await SharedPreferences.getInstance();
    imagename = pref.getString('userimgname') ?? "";
  }

  CountryDialog(BuildContext context) {
    return AlertDialog(
      title: Container(
        alignment: Alignment.center,
        child: TextField(
          textAlign: TextAlign.center,
          enabled: false,
          decoration: InputDecoration(
            isDense: true,
            isCollapsed: true,
            border: InputBorder.none,
            filled: false,
            fillColor: Color(0xFFF7F8FA),
            hintText: 'Select Country',
            hintStyle: TextDesigner(
                SDP.sdp(14), const Color(0xFFB492E8), 'm'),
          ),
        ),
      ),
      content: Container(
        width: SDP.sdp(500),
        height: SDP.sdp(400),
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: countryAreaCodes.length,
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: () {
                  Provider.of<FriendsProvider>(context, listen: false).UpdateCC(countryAreaCodes[index], countryNames[index], countryFlags[index]);
                  Navigator.pop(context);
                  setState(() {});
                },
                child: Container(
                  margin: EdgeInsets.all(SDP.sdp(5)),
                  height: SDP.sdp(30),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: SDP.sdp(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: SDP.sdp(35),
                          width: SDP.sdp(35),
                          child: Image(image : AssetImage(countryFlags[index])),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: SDP.sdp(10)),
                          child: SizedBox(
                            width: SDP.sdp(135),
                            child: Text(
                              countryNames[index],
                              style: TextDesigner(14, const Color(0xFF1A1C2D), 'r'),
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
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  height: SDP.sdp(25),
                  width: SDP.sdp(90),
                  margin: EdgeInsets.only(bottom: SDP.sdp(10)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SDP.sdp(8)),
                    color: const Color(0xFFB492E8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: SDP.sdp(10), right: SDP.sdp(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Cancel',
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
    );
  }

  CountryCodeConfirmationDialog(BuildContext diagContext) {
    return AlertDialog(
      title: Container(
        height: SDP.sdp(35),
        alignment: Alignment.center,
        child: TextField(
          textAlign: TextAlign.center,
          enabled: false,
          decoration: InputDecoration(
            isDense: true,
            isCollapsed: true,
            border: InputBorder.none,
            filled: false,
            fillColor: Color(0xFFF7F8FA),
            hintMaxLines: 2,
            hintText: 'Confirm country and \n country code ',
            hintStyle: TextDesigner(
                SDP.sdp(14), Color(0xFFB492E8), 'm'),
          ),
        ),
      ),
      content: Container(
        height: SDP.sdp(110),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: (){
                    showDialog(
                        barrierDismissible: false,
                        context: diagContext,
                        builder: (BuildContext diagContext) => CountryDialog(diagContext));
                  },
                  child: Container(
                    margin: EdgeInsets.all(SDP.sdp(5)),
                    height: SDP.sdp(35),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: SDP.sdp(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Consumer<FriendsProvider>(
                            builder: (context, val, child){
                              return Container(
                                height: SDP.sdp(30),
                                width: SDP.sdp(30),
                                child: Image(image : AssetImage(val.cflag)),
                              );
                            },
                          ),
                          Consumer<FriendsProvider>(
                            builder: (diagContext, val, child){
                              return Container(
                                margin: EdgeInsets.only(left: SDP.sdp(5)),
                                child: SizedBox(
                                  width: SDP.sdp(90),
                                  child: Text(
                                    val.ccountry,
                                    style: TextDesigner(14, const Color(0xFF1A1C2D), 'r'),
                                  ),
                                ),
                              );
                            },
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(onTap: (){
                  showDialog(
                      barrierDismissible: false,
                      context: diagContext,
                      builder: (BuildContext diagContext) => CountryDialog(diagContext));
                },
                  child: Consumer<FriendsProvider>(
                    builder: (diagContext, val, child){
                      return Container(
                        margin: EdgeInsets.all(SDP.sdp(5)),
                        height: SDP.sdp(35),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: SDP.sdp(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: SDP.sdp(10)),
                                child: SizedBox(
                                  width: SDP.sdp(40),
                                  child: Text(
                                    val.ccode,
                                    style: TextDesigner(14, const Color(0xFF1A1C2D), 'r'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Consumer<FriendsProvider>(
              builder: (diagContext, val, child){
                return Container(
                  margin: EdgeInsets.only(top: SDP.sdp(8)) ,
                  child: Text(val.ccode + " " + phone.text,
                    style: TextDesigner(SDP.sdp(12), Colors.black, 'r'),
                  ),
                );
              },
            ),
            Container(
              margin: EdgeInsets.only(top: SDP.sdp(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(diagContext).pop();
                    },
                    child: Container(
                      height: SDP.sdp(25),
                      width: SDP.sdp(90),
                      margin: EdgeInsets.only(right: SDP.sdp(10)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(SDP.sdp(8)),
                        color: Color(0xFFB492E8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: SDP.sdp(10), right: SDP.sdp(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Back',
                              style: TextDesigner(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.of(diagContext).pop();
                      FocusManager.instance.primaryFocus!.unfocus();
                      bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
                      if (isConnected == true) {
                        if(username.text.isEmpty){
                          usernameformkey.currentState!.validate();
                          userNameFocusNode.requestFocus();
                        }else{
                          if (!(accounttype == "User") && !virtualBusiness) {
                            LatLng latLng = _markers.first.position;
                            blatitude = latLng.latitude.toString();
                            blongitude = latLng.longitude.toString();
                          }
                          UpdateProfile(context);
                          updateUserNetworkList(context);
                        }
                      } else {
                        Constants.ShowSnackBar(
                            context, "Check your internet Connection!");
                      }
                    },
                    child: Container(
                      height: SDP.sdp(25),
                      width: SDP.sdp(90),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(SDP.sdp(8)),
                        color: Color(0xFFB492E8),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: SDP.sdp(10), right: SDP.sdp(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
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
          ],
        ),
      ),
    );
  }

  void _acquireCurrentLocation() async {
    _markers.clear();
    if (blatitude != "") {
      List<Placemark> placemarks = await placemarkFromCoordinates(double.tryParse(blatitude)!, double.tryParse(blongitude)!);
      Placemark place = placemarks[0];
      baddress.text = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}';
      GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: baddress.text == "" ? LatLng(45.45, 45.45) : LatLng(double.tryParse(blatitude)!, double.tryParse(blongitude)!),
            tilt: 59.440717697143555,
            zoom: 19.151926040649414,
          )
      ));
      _markers.add(
          Marker(
              markerId: const MarkerId('BID'),
              draggable: true,
              position: baddress.text == "" ? LatLng(45.45, 45.45) : LatLng(double.tryParse(blatitude)!, double.tryParse(blongitude)!),
              infoWindow: const InfoWindow(
                  snippet: 'Long press to move marker',
                  title: 'Business Location'
              ),
              onDragEnd: ((newPosition) async {
                List<Placemark> placemarks = await placemarkFromCoordinates(newPosition.latitude, newPosition.longitude);
                Placemark place = placemarks[0];
                baddress.text = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}';
              }
          ))
      );
      setState(() {});
    } else {
      bool serviceEnabled;
      loc.PermissionStatus permissionGranted;
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          ShowLocationDiag(context);
          return null;
        }
      }
      permissionGranted = await location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          ShowLocationDiag(context);
          return null;
        }
      }

      locationData = await location.getLocation();
      List<Placemark> placemarks = await placemarkFromCoordinates(locationData!.latitude!, locationData!.longitude!);
      Placemark place = placemarks[0];

      baddress.text = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';

      GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(locationData!.latitude!, locationData!.longitude!),
            tilt: 59.440717697143555,
            zoom: 19.151926040649414,
          )
      ));
      _markers.add(
          Marker(
              markerId: const MarkerId('BID'),
              draggable: true,
              position: LatLng(locationData!.latitude!, locationData!.longitude!),
              infoWindow: const InfoWindow(
                  snippet: 'Long press to move marker',
                  title: 'Business Location'
              ),
              onDragEnd: ((newPosition) async {
                List<Placemark> placemarks = await placemarkFromCoordinates(newPosition.latitude, newPosition.longitude);
                Placemark place = placemarks[0];
                baddress.text = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}';
              }
          ))
      );
      setState(() {});
    }
  }

  ShowLocationDiag(BuildContext context){
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
                Container(
                  margin: EdgeInsets.only(left: SDP.sdp(10)),
                  child: Row(
                    children: [
                      Container(
                          width: SDP.sdp(260),
                          child: Text("Unable to find your location", style: TextDesigner_L(SDP.sdp(14), const Color(0xFF1A1C2D), 'r'))),
                      GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Text("X", style: TextDesigner_L(SDP.sdp(14), const Color(0xFF1A1C2D), 'r'))),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: SDP.sdp(10), bottom: SDP.sdp(10) ),
                    child: Text(
                        textAlign: TextAlign.center,
                        "Enable location to pin your business location,\nelse enter manually.Select 'Virtual' business \nfor an internet based business", style: TextDesigner_L(SDP.sdp(12), const Color(0xFF1A1C2D), 'r'))),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    openAppSettings();
                  },
                  child: Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(240),
                    margin: EdgeInsets.only(top: SDP.sdp(10), bottom: SDP.sdp(10) ),
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
                            'ENABLE LOCATION',
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

  NetworksDialog(BuildContext context, List<NetworkslistModel> list) {
    title = "Title";
    url = "Url";
    erro = false;
    return AlertDialog(
      title: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: SDP.sdp(25),
            child: TextField(
              textAlign: TextAlign.center,
              enabled: false,
              decoration: InputDecoration(
                isDense: true,
                isCollapsed: true,
                border: InputBorder.none,
                filled: false,
                fillColor: Color(0xFFF7F8FA),
                hintText: 'Channel List',
                hintStyle: TextDesigner(
                    SDP.sdp(14), const Color(0xFFB492E8), 'm'),
              ),
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: Text('Add Custom Link',
                style: TextDesigner(
                    SDP.sdp(11), const Color(0xFFB492E8), 'r'),)
          ),
          Container(
            margin: EdgeInsets.only(top: SDP.sdp(5)),
            padding: EdgeInsets.all(SDP.sdp(8)),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(
                  Radius.circular(SDP.sdp(5)) //                 <--- border radius here
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: SDP.sdp(28),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(SDP.sdp(3)),
                    ),
                  ),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: InputDecoration(
                      contentPadding:EdgeInsets.only(left: SDP.sdp(8) , right: 0 , top: 0 , bottom: 0),
                      enabledBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(3))),
                        borderSide: const BorderSide(
                          color: Color(0xFFAAACAE),
                          width: .5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(3))),
                        borderSide: const BorderSide(
                          color: Color(0xFFAAACAE),
                          width: .5,
                        ),
                      ),
                      filled: true,
                      fillColor: Color(0xFFFFFFFF),
                      hintText: 'Title',
                      hintStyle: TextDesigner(
                          SDP.sdp(10), const Color(0xFFAAACAE), 'r'),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: SDP.sdp(8)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(SDP.sdp(3)),
                    ),
                  ),
                  child: Form(
                    key: formkey,
                    child: TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (value) {
                        url = value;
                      },
                      decoration: InputDecoration(
                        isCollapsed: true,
                        isDense: true,
                        contentPadding:EdgeInsets.only(left: SDP.sdp(8) , right: 0 , top: SDP.sdp(7) , bottom: SDP.sdp(7)),
                        enabledBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(3))),
                          borderSide: const BorderSide(
                            color: Color(0xFFAAACAE),
                            width: .5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(3))),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: .5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(3))),
                          borderSide: const BorderSide(
                            color: Color(0xFFAAACAE),
                            width: .5,
                          ),
                        ),
                        filled: true,
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(SDP.sdp(3))),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: .5,
                          ),
                        ),
                        fillColor: Color(0xFFFFFFFF),
                        hintText: 'URL',
                        hintStyle: TextDesigner(
                            SDP.sdp(10), const Color(0xFFAAACAE), 'r'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                child: Text('Add Social',
                  style: TextDesigner(
                      SDP.sdp(11), const Color(0xFFB492E8), 'r'),)
            ),
            Container(
              width: SDP.sdp(400),
              height: SDP.sdp(180),
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        print(list[index].networkvalue);
                        Controls.usernetworklist.add(list[index]);
                        Navigator.pop(context);
                        setState(() {});
                      },
                      child: Container(
                        height: SDP.sdp(30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: SDP.sdp(20),
                              width: SDP.sdp(20),
                              child: list[index].networkicon == ""
                                  ? Image.network('https://via.placeholder.com/150')
                                  : Image.network(list[index].networkicon!),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: SDP.sdp(10)),
                              child: SizedBox(
                                width: SDP.sdp(135),
                                child: Text(
                                  list[index].networkname == ""
                                      ? "Yes Yes Connect"
                                      : list[index].networkname!,
                                  style: TextDesigner(
                                      14, const Color(0xFF1A1C2D), 'r'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height: SDP.sdp(25),
                width: SDP.sdp(90),
                margin: EdgeInsets.only(top: SDP.sdp(0),bottom: SDP.sdp(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SDP.sdp(3)),
                  color: const Color(0xFFB492E8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Cancel',
                      style: TextDesigner(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                if(url == "" || url == "Url" || title == "" || title == "Title"){
                  Constants.ShowSnackBar(context, "Url or Title can't be empty");
                }else{
                  if(!erro){
                    NetworkslistModel custom = NetworkslistModel();
                    custom.networkid = 0;
                    custom.networkvalue = url;
                    custom.networkname = title;
                    custom.networkformat = "url";
                    custom.networkicon = "";
                    custom.networktype = "custom";
                    Controls.usernetworklist.add(custom);
                    setState(() {});
                    Navigator.pop(context);
                  }
                }
              },
              child: Container(
                height: SDP.sdp(25),
                width: SDP.sdp(90),
                margin: EdgeInsets.only(top: SDP.sdp(0),bottom: SDP.sdp(20), left: SDP.sdp(10)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SDP.sdp(3)),
                  color: const Color(0xFFB492E8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Next',
                      style: TextDesigner(SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    username.dispose();
    website.dispose();
    email.dispose();
    phone.dispose();
    baddress.dispose();
    cusaddress.dispose();
    qrtitle.dispose();
    empname.dispose();
    worktitle.dispose();
    workemail.dispose();
    btype.dispose();
    _controllers.clear();
    _titleControllers.clear();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

}
