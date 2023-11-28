import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:barcodeprinter/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:location/location.dart' as loc;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart' as Path;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import '../DataModers/CategoriesListModel.dart';
import '../DataModers/FrieList.dart';
import '../DataModers/GroupListModel.dart';
import '../DataModers/ProductServiceListDataModel.dart';
import '../SDP.dart';
import '../api/api_client.dart';
import '../utils/controls.dart';
import 'AddProductServicePage.dart';
import 'UpdateProductServicePage.dart';

class BusinessPage extends StatefulWidget {
  @override
  State<BusinessPage> createState() => _BusinessPageState();
}

class _BusinessPageState extends State<BusinessPage> with WidgetsBindingObserver  {
  bool _textFieldSelected = false;
  bool _editable = true;
  final String uploadUrl = 'http://qrlia.com/api/YesYesConnectUpdateProfileImage';
  final String imgurl = "http://qrlia.com/core/public/appusers/";
  bool isSelected = false;
  String linkName = 'Zomato';
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  Size? _size;
  String gender = "Product";
  List<GlobalKey<FormState>> _formKey = [];
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<FormState> BusinessNameformkey = GlobalKey<FormState>();
  String? imagename;
  String? UserRating;
  List<Categorieslist> list = [];
  List<Productslist> productlist = [];
  List<Productslist> servicelist = [];
  List<Friendslist> flist = [];
  List<Grouplist> grouplist = [];
  String? title = "", url = "", CategoryID;
  bool erro =  false;
  var userNameFocusNode = FocusNode();
  String hnt = "Enter Url", accounttype = "User", userimage = "", handle = "", longitude = "", latitude = "", blongitude = "", blatitude = "";
  TextEditingController BusinessName = TextEditingController(), website = TextEditingController(),
   Category = TextEditingController(), newCate = TextEditingController(),
   worktitle = TextEditingController(), BusinessDesc = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getProfile(context);
    getProductList(context);
    getGroupList(context);
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
        title: Text("Business Profile", style: TextDesigner(SDP.sdp(16), const Color(0xFF1A1C2D), 'b')),
      ),
      body: Container(
        height: _size!.height,
        width: _size!.width,
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/Login/bg.png"), fit: BoxFit.cover)),
        padding: EdgeInsets.only(top: SDP.sdp(8), left: SDP.sdp(8), right: SDP.sdp(8)),
        child: SingleChildScrollView(
          child: Column(children: [
            Column(
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
                          child: GestureDetector(
                            onTap: () async {
                              if(_editable){
                                try {
                                  image = await _picker.pickImage(source: ImageSource.gallery).then((value) {
                                    uploadImage(File(value!.path), context);
                                    return value;
                                  });
                                } catch (e) {
                                  Constants.PopupDialog(
                                      context, "No Image Selected!");
                                }
                              }
                            },
                            child: CircleAvatar(
                              backgroundColor: const Color(0xFFB492E8),
                              radius: SDP.sdp(10),
                              child: Icon(
                                Icons.edit,
                                size: SDP.sdp(10),
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                          )) : Container(),
                ]),
                Container(
                  margin: EdgeInsets.only(top: SDP.sdp(8)),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text("Business Logo", style: TextDesigner(SDP.sdp(12), const Color(0xFF1A1C2D), 'b'),
                  ),
                ),
              ],
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
                      controller: BusinessName,
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
                        hintText:  "Business name",
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
                        hintText: "Business Type",
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
                        hintText: "Business Website",
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
                      controller: BusinessDesc,
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
                        hintText: "Business Description",
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
                  GestureDetector(
                    onTap: () {
                      getCateList(context);
                    },
                    child: Container(
                      height: SDP.sdp(30),
                      width: SDP.sdp(210),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: Category,
                        style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                        textCapitalization: TextCapitalization.sentences,
                        enabled: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          filled: false,
                          fillColor: const Color(0xFFF2F2F2),
                          hintText: "Select Category",
                          hintStyle: TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                          suffixIcon: Icon(Icons.arrow_drop_down)
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      newCate.clear();
                      addcategoryDialog();
                    },
                    child: Container(
                      height: SDP.sdp(20),
                      width: SDP.sdp(60),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(SDP.sdp(10)),
                        color: const Color(0xFFB492E8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add New',
                            style: TextDesigner(SDP.sdp(10), const Color(0xFFFFFFFF), 'r'),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SDP.sdp(15),),
            Container(
              height: SDP.sdp(250),
              child: DefaultTabController(
                length: 3,
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
                        indicator: BoxDecoration(color: Color(0xFFB492E8)),
                        tabs: [
                          Tab(child : Text("Product",),),
                          Tab(child : Text("Services",),),
                          Tab(child : Text("Group",),),
                        ],
                      ),
                    ),
                  ), body: TabBarView(
                  children: [
                    productlist.isEmpty ? const Center(child: Text("No Products")) : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: productlist.length,
                        itemBuilder: (context,index){
                          return Container(
                            height: SDP.sdp(120),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: SDP.sdp(2)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: SDP.sdp(90),
                                    width: SDP.sdp(90),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: productlist[index].image == "" ? NetworkImage("http://qrlia.com/core/public/appusers/qrliaface-icon.png") : NetworkImage(productlist[index].image!),
                                        ),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(SDP.sdp(10))),
                                  ),
                                  SizedBox(width: SDP.sdp(5),),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: SDP.sdp(130),
                                            child: Text(productlist[index].name!, style: TextDesigner(SDP.sdp(12), const Color(0xFF1A1C2D), 'b'),
                                            ),
                                          ),
                                          productlist[index].file != "" ? GestureDetector(
                                              child: Icon(
                                                Icons.file_copy,
                                                size: SDP.sdp(15),
                                              )
                                          ) : Container(),
                                          PopupMenuButton(
                                            onSelected: (value) {
                                              if (value == "Update") {
                                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UpdateProductServicePage(productslistl: productlist[index])));
                                              }else if(value == "Delete"){
                                                deleteProdServc(productlist[index].id.toString());
                                              }
                                            },
                                            itemBuilder: (BuildContext context) {
                                              return {'Update','Delete'}.map((link) {
                                                return PopupMenuItem(
                                                  value: link,
                                                  child: Text(link),
                                                );
                                              }).toList();
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: SizedBox(
                                              width: SDP.sdp(165),
                                              child: Text(productlist[index].category!,
                                                style: TextDesigner(SDP.sdp(12), const Color(0xFF1A1C2D), 'r'),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: SizedBox(
                                          width: SDP.sdp(120),
                                          child: Text(productlist[index].description!,
                                            style: TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: SDP.sdp(5),),
                                      Container(
                                        width : SDP.sdp(120),
                                        child: RatingBar.builder(
                                          initialRating: double.tryParse(productlist[index].averageRating.toString())!,
                                          itemSize:SDP.sdp(10) ,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                      ),
                                      SizedBox(height: SDP.sdp(5),),
                                      Container(
                                        width: SDP.sdp(30),
                                        child: Text(productlist[index].price.toString(),
                                          style: TextDesigner(SDP.sdp(12), const Color(0xFFB492E8), 'b'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                    ),
                    servicelist.isEmpty ? const Center(child: Text("No Services")) : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: servicelist.length,
                        itemBuilder: (context,index){
                          return
                            Container(
                              height: SDP.sdp(120),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: SDP.sdp(2)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: SDP.sdp(90),
                                      width: SDP.sdp(90),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: userimage == "" ? NetworkImage(
                                                "http://qrlia.com/core/public/appusers/qrliaface-icon.png")
                                                : NetworkImage(userimage),
                                          ),
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.circular(SDP.sdp(10))),
                                    ),
                                    SizedBox(width: SDP.sdp(5),),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: SDP.sdp(130),
                                              child: Text(servicelist[index].name!, style: TextDesigner(SDP.sdp(12), const Color(0xFF1A1C2D), 'b'),
                                              ),
                                            ),
                                            servicelist[index].file != "" ? GestureDetector(
                                                child: Icon(
                                                  Icons.file_copy,
                                                  size: SDP.sdp(15),
                                                )
                                            ) : Container(),
                                            PopupMenuButton(
                                              onSelected: (value) {
                                                if (value == "Update") {
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UpdateProductServicePage(productslistl: servicelist[index])));
                                                }else if(value == "Delete"){
                                                  deleteProdServc(servicelist[index].id.toString());
                                                }
                                              },
                                              itemBuilder: (BuildContext context) {
                                                return {'Update','Delete'}.map((link) {
                                                  return PopupMenuItem(
                                                    value: link,
                                                    child: Text(link),
                                                  );
                                                }).toList();
                                              },
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              child: SizedBox(
                                                width: SDP.sdp(165),
                                                child: Text(servicelist[index].category!,
                                                  style: TextDesigner(SDP.sdp(12), const Color(0xFF1A1C2D), 'r'),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          child: SizedBox(
                                            width: SDP.sdp(120),
                                            child: Text(servicelist[index].description!,
                                              style: TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: SDP.sdp(5),),
                                        Container(
                                          width : SDP.sdp(120),
                                          child: RatingBar.builder(
                                            initialRating: double.tryParse(servicelist[index].averageRating.toString())!,
                                            itemSize:SDP.sdp(10) ,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          ),
                                        ),
                                        SizedBox(height: SDP.sdp(5),),
                                        Container(
                                          width: SDP.sdp(30),
                                          child: Text(servicelist[index].price.toString(),
                                            style: TextDesigner(SDP.sdp(12), const Color(0xFFB492E8), 'b'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                        }
                    ),
                    servicelist.isEmpty ? const Center(child: Text("No Group Members")) : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: grouplist.length,
                        itemBuilder: (context,index){
                          return
                            Container(
                              height: SDP.sdp(60),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: SDP.sdp(2)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                        backgroundImage: grouplist[index].memberImage == "" ? NetworkImage("http://qrlia.com/core/public/appusers/qrliaface-icon.png")
                                            : NetworkImage(grouplist[index].memberImage!),
                                        radius: SDP.sdp(15)),
                                    SizedBox(width: SDP.sdp(10),),
                                    Container(
                                      width: SDP.sdp(150),
                                      child: Text(grouplist[index].memberName!, style: TextDesigner(SDP.sdp(12), const Color(0xFF1A1C2D), 'r'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                        }
                    ),
                  ],
                ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                UpdateBusinessProfile(context);
              },
              child: Container(
                height: SDP.sdp(30),
                width: SDP.sdp(130),
                margin: EdgeInsets.only(top: SDP.sdp(10), left: SDP.sdp(5)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SDP.sdp(3)),
                  color: const Color(0xFFB492E8),
                ),
                child: Padding(
                  padding:
                  EdgeInsets.only(left: SDP.sdp(10), right: SDP.sdp(10)),
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
            ),
          ]),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.up,
        distance: SDP.sdp(50),
        children: [
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.add_box),
            onPressed: () {
              if(CategoryID != null){
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddProductServicePage(CateName: Category.text,CateId: CategoryID,)));
              }else{
                Constants.PopupDialog(context, "Category not selected");
              }
            },
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.account_tree),
            onPressed: () {
              getFriendsList(context);
            },
          ),
        ],
      ),
    );
  }

  UpdateBusinessProfile(BuildContext context) {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
    Constants.Loading(context);
    client.BusinessPageUpdateAPI(
            "807620388065912",
            Controls.id,
            BusinessName.text,
            imagename!,
            website.text,
            worktitle.text,
            BusinessDesc.text)
        .then((value) {
      Navigator.of(context).pop();
      if (value.code == "1") {
        Constants.ShowSnackBar(context, value.msg!);
        _getProfile(context);
      } else {
        Constants.PopupDialog(context, value.msg!);
      }
    }, onError: (covariant) {
      Navigator.of(context).pop();
      Constants.PopupDialog(context, "Server Not Responding!");
    });
  }

  _getProfile(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.GetBusinessPageAPI("807620388065912", Controls.id).then((value) {
        Navigator.of(context).pop();
        if (value.code == "1") {
          setState(() {
            BusinessName.text = value.businessPageName!;
            BusinessDesc.text = value.businessPageDescription!;
            website.text = value.businessPageWebsite!;
            worktitle.text = value.businessPageType!;
          });
        } else {
          Constants.PopupDialog(context, value.msg!);
        }
      }, onError: (covariant) {
        Navigator.of(context).pop();
        Constants.PopupDialog(
                context, "Server Not Responding!" + covariant.toString());
      });
    } else {
      Constants.PopupDialog(
              context, "Check your internet Connection!");
    }
  }

  getCateList(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.GetCateListAPI("807620388065912", Controls.id).then((value) {
        Navigator.of(context).pop();
        if (value.code == "1") {
          list = value.categorieslist!;
          CatePopupDialog();
        }
      }, onError: (covariant) {
        Navigator.of(context).pop();
        Constants.PopupDialog(context, "Server Not Responding!" + covariant.toString());
      });
    } else {}
  }

  getProductList(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.GetProdListAPI("807620388065912", Controls.id).then((value) {
        if (value.code == "1") {
          productlist = value.productslist!.where((friend) => friend.type!.contains("Product")).toList();
          servicelist = value.productslist!.where((friend) => friend.type!.contains("Service")).toList();
          setState(() {});
        }
      }, onError: (covariant) {
        Constants.PopupDialog(context, "Server Not Responding!" + covariant.toString());
      });
    } else {}
  }

  getGroupList(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.GetGroupListAPI("807620388065912", Controls.id).then((value) {
        if (value.code == "1") {
          grouplist = value.grouplist!;
          setState(() {});
        }
      }, onError: (covariant) {
        Constants.PopupDialog(context, "Server Not Responding!" + covariant.toString());
      });
    } else {}
  }

  AddGroup(String fid) async {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
    client.AddGroupAPI("807620388065912", Controls.id, fid).then((value) {
          if (value.code == "1") {
            Constants.ShowSnackBar(context, value.msg.toString());
          } else {
            Constants.PopupDialog(context, value.msg.toString());
          }
        }, onError: (covariant) {
      Constants.PopupDialog(context, "Check your internet Connection!");
    });
  }

  addCate() async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.AddCateAPI("807620388065912", Controls.id, newCate.text).then((value) {
        Navigator.of(context).pop();
        if (value.code == "1") {}
      }, onError: (covariant) {
        Navigator.of(context).pop();
        Constants.PopupDialog(context, "Server Not Responding!" + covariant.toString());
      });
    } else {}
  }

  deleteCate() async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.AddCateAPI("807620388065912", Controls.id, newCate.text).then((value) {
        Navigator.of(context).pop();
        if (value.code == "1") {}
      }, onError: (covariant) {
        Navigator.of(context).pop();
        Constants.PopupDialog(context, "Server Not Responding!" + covariant.toString());
      });
    } else {}
  }

  deleteProdServc(String id) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.DeleteProductServiceAPI("807620388065912", Controls.id, id).then((value) {
        Navigator.of(context).pop();
        if (value.code == "1") {
          getProductList(context);
        }
      }, onError: (covariant) {
        Navigator.of(context).pop();
        Constants.PopupDialog(context, "Server Not Responding!" + covariant.toString());
      });
    } else {}
  }

  UpdateCate() async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.UpdateCateAPI("807620388065912", Controls.id, CategoryID! ,newCate.text).then((value) {
        Navigator.of(context).pop();
        if (value.code == "1") {}
      }, onError: (covariant) {
        Navigator.of(context).pop();
        Constants.PopupDialog(context, "Server Not Responding!" + covariant.toString());
      });
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
      Constants.PopupDialog(context, "Server Not Responding!" + covariant.toString());
    });
  }

  addcategoryDialog() {
    return showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SDP.sdp(0)),
        ),
        context: context,
        builder: (context) => Container(
          height: SDP.sdp(150),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Add New Category", style: TextDesigner(SDP.sdp(16), const Color(0xFF1A1C2D), 'b')),
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
                          controller: newCate,
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
                            hintText:  "Category Name",
                            hintStyle: TextDesigner(
                                SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    addCate();
                  },
                  child: Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(130),
                    margin: EdgeInsets.only(top: SDP.sdp(10), left: SDP.sdp(5)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SDP.sdp(3)),
                      color: const Color(0xFFB492E8),
                    ),
                    child: Padding(
                      padding:
                      EdgeInsets.only(left: SDP.sdp(10), right: SDP.sdp(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Save',
                            style: TextDesigner(
                                SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
          ),
        )
    );
  }

  updatecategoryDialog() {
    return showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SDP.sdp(0)),
        ),
        context: context,
        builder: (context) => Container(
          height: SDP.sdp(150),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Update Category", style: TextDesigner(SDP.sdp(16), const Color(0xFF1A1C2D), 'b')),
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
                          controller: newCate,
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
                            hintText:  "Category Name",
                            hintStyle: TextDesigner(SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    UpdateCate();
                  },
                  child: Container(
                    height: SDP.sdp(30),
                    width: SDP.sdp(130),
                    margin: EdgeInsets.only(top: SDP.sdp(10), left: SDP.sdp(5)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SDP.sdp(3)),
                      color: const Color(0xFFB492E8),
                    ),
                    child: Padding(
                      padding:
                      EdgeInsets.only(left: SDP.sdp(10), right: SDP.sdp(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Save',
                            style: TextDesigner(
                                SDP.sdp(12), const Color(0xFFFFFFFF), 'r'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]
          ),
        )
    );
  }

  CatePopupDialog() {
    Size _size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: SDP.sdp(250),
        child: Column(
            children: [
              SizedBox(
                height: SDP.sdp(10),
              ),
              Container(
                margin: EdgeInsets.only(top: SDP.sdp(15), left: SDP.sdp(2)),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose Category',
                  style: TextDesigner(SDP.sdp(12),const Color(0xFF000000),'b'),
                ),
              ),
              Container(
                height: SDP.sdp(190),
                child: Stack(
                  children: [ list.isEmpty ?
                  const Center(child: Text("There are no categories to show")) : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: list.length,
                      itemBuilder: (context,index){
                        return Container(
                          margin: EdgeInsets.all(SDP.sdp(5)),
                          width: _size.width-25,
                          height: SDP.sdp(40),
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                            ),
                          ),child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.pop(context);
                                    Category.text = list[index].categoryName!;
                                    CategoryID = list[index].categoryId.toString();
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: SDP.sdp(0)),
                                    child: SizedBox(
                                      width: SDP.sdp(230),
                                      child:
                                      Text(
                                        list[index].categoryName!,
                                        style: TextDesigner(SDP.sdp(11), const Color(0xFF1A1C2D), 'r'),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                newCate.text = list[index].categoryName!;
                                CategoryID = list[index].categoryId.toString();
                                updatecategoryDialog();
                              },
                              child: CircleAvatar(
                                backgroundColor: const Color(0xFFB492E8),
                                radius: SDP.sdp(10),
                                child: Icon(
                                  Icons.edit,
                                  size: SDP.sdp(10),
                                  color: const Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                            SizedBox(width: SDP.sdp(5)),
                            CircleAvatar(
                              backgroundColor: Colors.redAccent,
                              radius: SDP.sdp(10),
                              child: Icon(
                                Icons.delete_forever,
                                size: SDP.sdp(10),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        );
                      }
                  ),
                  ],
                ),
              )
            ]
        ),
      ),
    );
  }

  addGroupDialog() {
    return showMaterialModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SDP.sdp(0)),
        ),
        context: context,
        builder: (context) => Container(
          height: SDP.sdp(250),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: SDP.sdp(10)),
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
                    hintText: 'Add To Group',
                    hintStyle: TextDesigner(
                        SDP.sdp(14), const Color(0xFFB492E8), 'm'),
                  ),
                ),
              ),
              Container(
                height: SDP.sdp(200),
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: flist.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          AddGroup(flist[index].frienduserid.toString());
                        },
                        child: Container(
                          margin: EdgeInsets.all(SDP.sdp(5)),
                          height: SDP.sdp(30),
                          child: Padding(
                            padding: EdgeInsets.only(bottom: SDP.sdp(3)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                    backgroundImage: flist[index].friendimage == ""
                                        ? CachedNetworkImageProvider(
                                        "http://mwsworkroom.com/YesYes/core/public/appusers/zappect-logo.png")
                                        : CachedNetworkImageProvider(
                                        flist[index].friendimage!)),
                                Container(
                                  margin: EdgeInsets.only(left: SDP.sdp(10)),
                                  child: SizedBox(
                                    width: SDP.sdp(135),
                                    child: Text(
                                      flist[index].friendusername!,
                                      style: TextDesigner(
                                          14, const Color(0xFF1A1C2D), 'r'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        )
    );
  }

  Future<void> getFriendsList(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.FriendsList('807620388065912', Controls.id).then((value) {
        Navigator.of(context).pop();
        if (value.code == "1") {
          flist = value.friendslist;
          addGroupDialog();
        }
        else {}
      },
      onError: (covariant) {
        Navigator.of(context).pop();
        Constants.PopupDialog(context, "Server Not Responding! " + covariant.toString());
      });
    }
  }


  @override
  void dispose() {
    BusinessName.dispose();
    website.dispose();
    Category.dispose();
    newCate.dispose();
    worktitle.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
