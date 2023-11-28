import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import '../DataModers/FrieList.dart';
import '../Local Data/LocalDatabase.dart';
import '../SDP.dart';
import '../api/api_client.dart';
import '../utils/constants.dart';
import '../utils/controls.dart';


class FriendsProvider extends ChangeNotifier{
  FriendsProvider();

  List<Friendslist> list = [];
  List<Friendslist> filteredlist = [];

  List<Contact>? contacts = [];
  bool permissionDenied = false;

  bool isLoading = true;
  String notiCount = "0";
  List<bool> onError = [];

  bool onerror = false;
  bool usernameerror = false;
  bool allowpass = false;

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


  String ccode = "+1";
  String ccountry = "United States";
  String cflag = "assets/flags/_us.png";

  String address = "";
  loc.Location location = loc.Location();
  loc.LocationData? locationData;

  void runFilter(String enteredKeyword) {
    List<Friendslist> results = [];
    if (enteredKeyword.isEmpty) {
      results = list;
    } else {
      results = list.where((friend) =>
          friend.friendname!.toLowerCase().contains(enteredKeyword.toLowerCase())
          || friend.friendusername!.toLowerCase().contains(enteredKeyword.toLowerCase())
          || friend.friendemail!.toLowerCase().contains(enteredKeyword.toLowerCase())
          || friend.friendphone!.toLowerCase().contains(enteredKeyword.toLowerCase())
          || friend.workbusinessname!.toLowerCase().contains(enteredKeyword.toLowerCase())
          || friend.workemail!.toLowerCase().contains(enteredKeyword.toLowerCase())
          || friend.worktitle!.toLowerCase().contains(enteredKeyword.toLowerCase())
          || friend.businesstype!.toLowerCase().contains(enteredKeyword.toLowerCase())
          || friend.meetingaddress!.toLowerCase().contains(enteredKeyword.toLowerCase())
          || friend.about!.toLowerCase().contains(enteredKeyword.toLowerCase())
          || friend.businessaddress!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    filteredlist = results;
    notifyListeners();
  }

  Future<void> getFriendsList(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.FriendsList('807620388065912', Controls.id).then((value) {
        Navigator.of(context).pop();
        Controls.friends = value;
        if (Controls.friends.code == "1") {
          list = Controls.friends.friendslist;
          filteredlist = list;
          addIFriends(list);
          notifyListeners();
        }
        else {}
      },
      onError: (covariant) {
        Navigator.of(context).pop();
                Constants.PopupDialog(context, "Server Not Responding! " + covariant.toString());
      });
    } else {
      localFriends();
    }
  }

  Future<void> deleteFriends() async {
    await LocalDatabase.deleteAllItem();
  }

  Future<void> addIFriends(List<Friendslist> friendslist) async {
    deleteFriends();
    await LocalDatabase.createBulkItems(friendslist);
  }

  void localFriends() async {
    final data = await LocalDatabase.getItems();
    if (data != null) {
      filteredlist.clear();
      data.forEach((v) {
        filteredlist.add(Friendslist.fromJson(v));
        list = filteredlist;
      });
    }
    notifyListeners();
  }

  UrlValidateValues(bool value) {
    onError.add(value);
  }

  UrlValidate(int index,bool value) {
    onError[index] = value;
    notifyListeners();
  }

  UpdateCC(String cc, String ccou, String cf) {
    ccode = cc;
    cflag = cf;
    ccountry = ccou;
    notifyListeners();
  }

  void acquireCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return null;
      }
    }

    locationData = await location.getLocation();
    List<Placemark> placemarks = await placemarkFromCoordinates(locationData!.latitude!, locationData!.longitude!);
    Placemark place = placemarks[0];

    Controls.countrtcode = place.isoCountryCode!;
    final index = countryCodes.indexWhere((element) =>
    element == Controls.countrtcode);
    if (index >= 0) {
      ccode = countryAreaCodes[index];
      cflag = countryFlags[index];
      ccountry = countryNames[index];
      notifyListeners();
    }
  }

  Future fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      permissionDenied = true;
    } else {
      final cont = await FlutterContacts.getContacts();
      contacts = cont;
    }
    notifyListeners();
  }
}