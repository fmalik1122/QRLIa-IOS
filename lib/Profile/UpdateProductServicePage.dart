import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

import '../DataModers/CategoriesListModel.dart';
import '../DataModers/ProductServiceListDataModel.dart';
import '../SDP.dart';
import '../api/api_client.dart';
import '../utils/constants.dart';
import '../utils/controls.dart';

class UpdateProductServicePage extends StatefulWidget {

  Productslist? productslistl;

  UpdateProductServicePage({this.productslistl}) : super();

  @override
  State<UpdateProductServicePage> createState() => _UpdateProductServicePageState(productslistl!);
}

class _UpdateProductServicePageState extends State<UpdateProductServicePage>{
  bool _textFieldSelected = false;
  bool _editable = true;
  final String uploadUrl = 'http://qrlia.com/api/YesYesConnectUpdateProfileImage';
  final String imgurl = "http://qrlia.com/core/public/appusers/";
  bool isSelected = false;
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  Size? _size;
  String gender = "Product";
  String type = "Image";
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  GlobalKey<FormState> usernameformkey = GlobalKey<FormState>();
  String? imagename, filename;
  List<Categorieslist> list = [];
  String? Category, CategoryID;
  var userNameFocusNode = FocusNode();
  String userimage = "";
  Productslist? productslistl;
  TextEditingController username = TextEditingController(), website = TextEditingController() , email = TextEditingController(), phone = TextEditingController(),
   userphone = TextEditingController(), baddress = TextEditingController(), newCate = TextEditingController(),
   worktitle = TextEditingController(), workemail = TextEditingController(), btype = TextEditingController(), desc = TextEditingController(), about = TextEditingController();

  _UpdateProductServicePageState(Productslist _productslist) {
    productslistl = _productslist;
  }

  @override
  void initState() {
    super.initState();
    getCateList(context);
    gender = productslistl!.type!;
    userimage = productslistl!.image!;
    imagename = productslistl!.image!.split("/").last;
    username.text = productslistl!.name!;
    desc.text = productslistl!.description!;
    website.text = productslistl!.price.toString();
    worktitle.text = productslistl!.category!;
    type = productslistl!.fileType!;
    filename = productslistl!.file!.split("/").last;
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
        title: Text("Product/Service", style: TextDesigner(SDP.sdp(16), const Color(0xFF1A1C2D), 'b')),
      ),
      body: Container(
        height: _size!.height,
        width: _size!.width,
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/Login/bg.png"), fit: BoxFit.cover)),
        padding: EdgeInsets.only(
            top: SDP.sdp(8), left: SDP.sdp(8), right: SDP.sdp(8)),
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
                              image: userimage == "" ? NetworkImage("http://qrlia.com/core/public/appusers/qrliaface-icon.png")
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
                  child: Text("Product/Service Logo", style: TextDesigner(SDP.sdp(12), const Color(0xFF1A1C2D), 'b'),
                  ),
                ),
              ],
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RadioListTile(
                    title: const Text("Product"),
                    value: "Product",
                    groupValue: gender,
                    onChanged: (value){
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text("Service"),
                    value: "Service",
                    groupValue: gender,
                    onChanged: (value){
                      setState(() {
                        gender = value.toString();
                      });
                    },
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
                            controller: username,
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
                              hintText:  "Product/Service Name",
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
                            controller: desc,
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
                              hintText: "Description",
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
                              hintText:  "Price",
                              hintStyle: TextDesigner(
                                  SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      CatePopupDialog();
                    },
                    child: Container(
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
                              enabled: false,
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
                                hintText: "Category",
                                hintStyle: TextDesigner(
                                    SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  RadioListTile(
                    title: const Text("Image"),
                    value: "Image",
                    groupValue: type,
                    onChanged: (value){
                      setState(() {
                        type = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text("PDF"),
                    value: "PDF",
                    groupValue: type,
                    onChanged: (value){
                      setState(() {
                        type = value.toString();
                      });
                    },
                  ),
                  type == "PDF" ? Container(
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
                            navigateTofileopner();
                          },
                          child: Container(
                            height: SDP.sdp(30),
                            width: SDP.sdp(250),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              style : TextDesigner(SDP.sdp(11), const Color(0xFF000000), 'r'),
                              textCapitalization: TextCapitalization.sentences,
                              enabled: false,
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
                                hintText: filename ?? "Upload File",
                                hintStyle: TextDesigner(
                                    SDP.sdp(11), const Color(0xFFAAACAE), 'r'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) : Container(),
                ]
            ),
            InkWell(
              onTap: () async {
                AddProductService(context);
              },
              child: Container(
                height: SDP.sdp(50),
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
    );
  }

  AddProductService(BuildContext context) {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
    Constants.Loading(context);
    client.UpdateProductServiceAPI(
            "807620388065912", Controls.id, gender,
            username.text,
            productslistl!.id.toString(),
            desc.text,
            website.text,
            CategoryID!,
            type,
            imagename!,
            filename!)
        .then((value) {
      Navigator.of(context).pop();
      if (value.code == "1") {
        Navigator.pop(context);
      } else {
        Constants.PopupDialog(context, value.msg!);
      }
    }, onError: (covariant) {
      Navigator.of(context).pop();
      Constants.PopupDialog(context, "Server Not Responding!");
    });
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

  Future<void> navigateTofileopner() async {
    final result= await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if(result==null)return;
    final files = result.files.first;
    print(files.extension);
    if(files.extension=='pdf'){
      filename = files.name;
      setState(() {

      });
    }
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
                                    worktitle.text = list[index].categoryName!;
                                    CategoryID = list[index].categoryId.toString();
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

  getCateList(BuildContext context) async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == true) {
      Constants.Loading(context);
      final client = ApiClient(Dio(BaseOptions(contentType: "application/x-www-form-urlencoded")));
      client.GetCateListAPI("807620388065912", Controls.id).then((value) {
        Navigator.of(context).pop();
        if (value.code == "1") {
          list = value.categorieslist!;
          CategoryID = list.where((friend) => friend.categoryName!.contains(Category!)).toList().first.categoryId.toString();
        }
      }, onError: (covariant) {
        Navigator.of(context).pop();
        Constants.PopupDialog(context, "Server Not Responding!" + covariant.toString());
      });
    } else {}
  }

  @override
  void dispose() {
    username.dispose();
    website.dispose();
    email.dispose();
    userphone.dispose();
    baddress.dispose();
    newCate.dispose();
    worktitle.dispose();
    workemail.dispose();
    btype.dispose();
    desc.dispose();
    super.dispose();
  }
}
