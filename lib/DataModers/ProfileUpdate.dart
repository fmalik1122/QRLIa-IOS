class ProfileUpdate {
  String? code;
  String? msg;
  String? businessname;
  String? businessimage;
  String? email;
  String? businesscategoryid;
  String? orderlinkone;
  String? orderlinktwo;
  String? orderlinkthree;
  String? orderlinkfour;
  String? businessaddress;
  String? businesslongitude;
  String? businesslatitude;

  ProfileUpdate(
      {this.code,
        this.msg,
        this.businessname,
        this.businessimage,
        this.email,
        this.businesscategoryid,
        this.orderlinkone,
        this.orderlinktwo,
        this.orderlinkthree,
        this.orderlinkfour,
        this.businessaddress,
        this.businesslongitude,
        this.businesslatitude});

  ProfileUpdate.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    businessname = json['businessname'];
    businessimage = json['businessimage'];
    email = json['email'];
    businesscategoryid = json['businesscategoryid'];
    orderlinkone = json['orderlinkone'];
    orderlinktwo = json['orderlinktwo'];
    orderlinkthree = json['orderlinkthree'];
    orderlinkfour = json['orderlinkfour'];
    businessaddress = json['businessaddress'];
    businesslongitude = json['businesslongitude'];
    businesslatitude = json['businesslatitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['businessname'] = this.businessname;
    data['businessimage'] = this.businessimage;
    data['email'] = this.email;
    data['businesscategoryid'] = this.businesscategoryid;
    data['orderlinkone'] = this.orderlinkone;
    data['orderlinktwo'] = this.orderlinktwo;
    data['orderlinkthree'] = this.orderlinkthree;
    data['orderlinkfour'] = this.orderlinkfour;
    data['businessaddress'] = this.businessaddress;
    data['businesslongitude'] = this.businesslongitude;
    data['businesslatitude'] = this.businesslatitude;
    return data;
  }
}
