class Profile{
  String? code;
  String? msg;
  String? accounttype;
  int? isVirtualBusiness;
  String? username;
  String? qrtitle;
  String? name;
  String? userimage;
  String? businessaddress;
  String? cusaddress;
  String? businesslongitude;
  String? businesslatitude;
  String? businesstype;
  String? workbusinessname;
  String? worktitle;
  String? workemail;
  String? website;
  String? phone;
  String? email;
  String? about;


  Profile(
      {this.code,
        this.msg,
        this.accounttype,
        this.isVirtualBusiness,
        this.username,
        this.qrtitle,
        this.name,
        this.userimage,
        this.businessaddress,
        this.cusaddress,
        this.businesslongitude,
        this.businesslatitude,
        this.businesstype,
        this.workbusinessname,
        this.worktitle,
        this.workemail,
        this.website,
        this.phone,
        this.email,
        this.about});

  Profile.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    accounttype = json['accounttype'];
    isVirtualBusiness = json['IsVirtualBusiness'];
    username = json['username'];
    qrtitle = json['qrtitle'];
    name = json['name'];
    userimage = json['userimage'];
    businessaddress = json['businessaddress'];
    cusaddress = json['cusaddress'];
    businesslongitude = json['businesslongitude'];
    businesslatitude = json['businesslatitude'];
    businesstype = json['businesstype'];
    workbusinessname = json['workbusinessname'];
    worktitle = json['worktitle'];
    workemail = json['workemail'];
    website = json['website'];
    phone = json['phone'];
    email = json['email'];
    about = json['about'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['accounttype'] = this.accounttype;
    data['IsVirtualBusiness'] = this.isVirtualBusiness;
    data['username'] = this.username;
    data['qrtitle'] = this.qrtitle;
    data['name'] = this.name;
    data['userimage'] = this.userimage;
    data['businessaddress'] = this.businessaddress;
    data['cusaddress'] = this.cusaddress;
    data['businesslongitude'] = this.businesslongitude;
    data['businesslatitude'] = this.businesslatitude;
    data['businesstype'] = this.businesstype;
    data['workbusinessname'] = this.workbusinessname;
    data['worktitle'] = this.worktitle;
    data['workemail'] = this.workemail;
    data['website'] = this.website;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['about'] = this.about;
    return data;
  }
}