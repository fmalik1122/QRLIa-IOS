class SettingsData{
  String? code;
  String? msg;
  int? webprofileshow;
  int? sociallinksshow;
  int? profilepicshow;
  int? locationshow;
  int? phonenumbershow;
  int? businessemail;
  int? companyname;
  int? worktitle;
  String? accounttype;
  int? profileshare;
  String? phone;
  String? email;
  String? webprofilelink;

  SettingsData(
      { this.code,
        this.msg,
        this.webprofileshow,
        this.sociallinksshow,
        this.profilepicshow,
        this.locationshow,
        this.phonenumbershow,
        this.businessemail,
        this.companyname,
        this.worktitle,
        this.accounttype,
        this.profileshare,
        this.phone,
        this.email,
        this.webprofilelink,
      });

  SettingsData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    webprofileshow = json['webprofileshow'];
    sociallinksshow = json['sociallinksshow'];
    profilepicshow = json['profilepicshow'];
    locationshow = json['locationshow'];
    phonenumbershow = json['phonenumbershow'];
    businessemail = json['businessemail'];
    companyname = json['companyname'];
    worktitle = json['worktitle'];
    accounttype = json['accounttype'];
    profileshare = json['allowprofilesharing'];
    phone = json['phone'];
    email = json['email'];
    webprofilelink = json['webprofilelink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['webprofileshow'] = this.webprofileshow;
    data['sociallinksshow'] = this.sociallinksshow;
    data['profilepicshow'] = this.profilepicshow;
    data['locationshow'] = this.locationshow;
    data['phonenumbershow'] = this.phonenumbershow;
    data['businessemail'] = this.businessemail;
    data['companyname'] = this.companyname;
    data['worktitle'] = this.worktitle;
    data['accounttype'] = this.accounttype;
    data['allowprofilesharing'] = this.profileshare;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['webprofilelink'] = this.webprofilelink;
    return data;
  }
}
