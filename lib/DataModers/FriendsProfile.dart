class FriendProfile {
  String? code;
  String? msg;
  int? connectionid;
  int? blockstatus;
  int? blockedby;
  String? friendaccttype;
  int? isVirtualBusiness;
  String? friendbusinesstype;
  String? friendusername;
  String? friendname;
  String? friendimage;
  String? friendemail;
  String? friendphone;
  String? friendcountrycode;
  String? meetingdatetime;
  String? meetingcomment;
  String? meetingselfie;
  String? meetingaddress;
  String? meetinglongitude;
  String? meetinglatitude;
  String? businessaddress;
  String? cusaddress;
  String? businesslongitude;
  String? businesslatitude;
  int? allowprofilesharing;
  String? workbusinessname;
  String? worktitle;
  String? workemail;
  String? website;
  String? about;
  int? webprofileshow;

  FriendProfile(
      {this.code,
        this.msg,
        this.connectionid,
        this.blockstatus,
        this.blockedby,
        this.friendaccttype,
        this.isVirtualBusiness,
        this.friendbusinesstype,
        this.friendusername,
        this.friendname,
        this.friendimage,
        this.friendemail,
        this.friendphone,
        this.friendcountrycode,
        this.meetingdatetime,
        this.meetingcomment,
        this.meetingselfie,
        this.meetingaddress,
        this.meetinglongitude,
        this.meetinglatitude,
        this.businessaddress,
        this.cusaddress,
        this.businesslongitude,
        this.businesslatitude,
        this.allowprofilesharing,
        this.workbusinessname,
        this.worktitle,
        this.workemail,
        this.website,
        this.webprofileshow,
        this.about});

  FriendProfile.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    connectionid = json['connectionid'];
    blockstatus = json['blockstatus'];
    blockedby = json['blockedby'];
    friendaccttype = json['friendaccttype'];
    isVirtualBusiness = json['IsVirtualBusiness'];
    friendbusinesstype = json['friendbusinesstype'];
    friendusername = json['friendusername'];
    friendname = json['friendname'];
    friendimage = json['friendimage'];
    friendemail = json['friendemail'];
    friendphone = json['friendphone'];
    friendcountrycode = json['friendcountrycode'];
    meetingdatetime = json['meetingdatetime'];
    meetingcomment = json['meetingcomment'];
    meetingselfie = json['meetingselfie'];
    meetingaddress = json['meetingaddress'];
    meetinglongitude = json['meetinglongitude'];
    meetinglatitude = json['meetinglatitude'];
    businessaddress = json['businessaddress'];
    cusaddress = json['cusaddress'];
    businesslongitude = json['businesslongitude'];
    businesslatitude = json['businesslatitude'];
    allowprofilesharing = json['allowprofilesharing'];
    workbusinessname = json['workbusinessname'];
    worktitle = json['worktitle'];
    workemail = json['workemail'];
    website = json['website'];
    webprofileshow = json['webprofileshow'];
    about = json['about'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['connectionid'] = this.connectionid;
    data['blockstatus'] = this.blockstatus;
    data['blockedby'] = this.blockedby;
    data['friendaccttype'] = this.friendaccttype;
    data['IsVirtualBusiness'] = this.isVirtualBusiness;
    data['friendbusinesstype'] = this.friendbusinesstype;
    data['friendusername'] = this.friendusername;
    data['friendname'] = this.friendname;
    data['friendimage'] = this.friendimage;
    data['friendemail'] = this.friendemail;
    data['friendphone'] = this.friendphone;
    data['friendcountrycode'] = this.friendcountrycode;
    data['meetingdatetime'] = this.meetingdatetime;
    data['meetingcomment'] = this.meetingcomment;
    data['meetingselfie'] = this.meetingselfie;
    data['meetingaddress'] = this.meetingaddress;
    data['meetinglongitude'] = this.meetinglongitude;
    data['meetinglatitude'] = this.meetinglatitude;
    data['businessaddress'] = this.businessaddress;
    data['cusaddress'] = this.cusaddress;
    data['businesslongitude'] = this.businesslongitude;
    data['businesslatitude'] = this.businesslatitude;
    data['allowprofilesharing'] = this.allowprofilesharing;
    data['workbusinessname'] = this.workbusinessname;
    data['worktitle'] = this.worktitle;
    data['workemail'] = this.workemail;
    data['website'] = this.website;
    data['webprofileshow'] = this.webprofileshow;
    data['about'] = this.about;
    return data;
  }
}