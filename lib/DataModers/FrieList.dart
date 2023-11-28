class Friends {
  String? code;
  String? msg;
  List<Friendslist> friendslist = [];

  Friends({this.code, this.msg, required this.friendslist});

  Friends.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['friendslist'] != null) {
      friendslist = <Friendslist>[];
      json['friendslist'].forEach((v) {
        friendslist.add(new Friendslist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.friendslist != null) {
      data['friendslist'] =
          this.friendslist.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class Friendslist {
  int? connectionid;
  int? frienduserid;
  String? friendname;
  String? friendusername;
  String? friendimage;
  String? requestid;
  String? requeststatus;
  String? requestdatetime;
  String? friendemail;
  String? friendphone;
  String? meetingcomment;
  String? meetingselfie;
  String? meetingaddress;
  String? meetinglongitude;
  String? meetinglatitude;
  String? friendaccttype;
  String? businessaddress;
  String? businesslongitude;
  String? businesslatitude;
  int? blockstatus ;
  int? blockedby ;
  String? businesstype ;
  String? workbusinessname ;
  String? worktitle ;
  String? workemail ;
  String? website;
  String? about;
  String? meetingdatetime;
  int? webprofileshow;
  int? IsVirtualBusiness;

  Friendslist(
      { this.connectionid,
        this.frienduserid,
        this.friendname,
        this.friendusername,
        this.friendimage,
        this.requestid,
        this.requeststatus,
        this.requestdatetime,
        this.friendemail,
        this.friendphone,
        this.meetingcomment,
        this.meetingselfie,
        this.meetingaddress,
        this.meetinglongitude,
        this.meetinglatitude,
        this.friendaccttype,
        this.businessaddress,
        this.businesslongitude,
        this.businesslatitude,
        this.blockstatus,
        this.blockedby,
        this.businesstype,
        this.workbusinessname,
        this.worktitle,
        this.workemail,
        this.website,
        this.about,
        this.meetingdatetime,
        this.webprofileshow,
        this.IsVirtualBusiness});

  Friendslist.fromJson(Map<String, dynamic> json) {
    connectionid = json['connectionid'];
    frienduserid = json['frienduserid'];
    friendname = json['friendname'];
    friendusername = json['friendusername'];
    friendimage = json['friendimage'];
    requestid = json['requestid'];
    requeststatus = json['requeststatus'];
    requestdatetime = json['requestdatetime'];
    friendemail = json['friendemail'];
    friendphone = json['friendphone'];
    meetingcomment = json['meetingcomment'];
    meetingselfie = json['meetingselfie'];
    meetingaddress = json['meetingaddress'];
    meetinglongitude = json['meetinglongitude'];
    meetinglatitude = json['meetinglatitude'];
    friendaccttype = json['friendaccttype'];
    businessaddress = json['businessaddress'];
    businesslongitude = json['businesslongitude'];
    businesslatitude = json['businesslatitude'];
    blockstatus = json['blockstatus'];
    blockedby = json['blockedby'];
    businesstype = json['businesstype'];
    workbusinessname = json['workbusinessname'];
    worktitle = json['worktitle'];
    workemail = json['workemail'];
    website = json['website'];
    about = json['about'];
    meetingdatetime = json['meetingdatetime'];
    webprofileshow = json['webprofileshow'];
    IsVirtualBusiness = json['IsVirtualBusiness'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['connectionid'] = this.connectionid;
    data['frienduserid'] = this.frienduserid;
    data['friendname'] = this.friendname;
    data['friendusername'] = this.friendusername;
    data['friendimage'] = this.friendimage;
    data['requestid'] = this.requestid;
    data['requeststatus'] = this.requeststatus;
    data['requestdatetime'] = this.requestdatetime;
    data['friendemail'] = this.friendemail;
    data['friendphone'] = this.friendphone;
    data['meetingcomment'] = this.meetingcomment;
    data['meetingselfie'] = this.meetingselfie;
    data['meetingaddress'] = this.meetingaddress;
    data['meetinglongitude'] = this.meetinglongitude;
    data['meetinglatitude'] = this.meetinglatitude;
    data['friendaccttype'] = this.friendaccttype;
    data['businessaddress'] = this.businessaddress;
    data['businesslongitude'] = this.businesslongitude;
    data['businesslatitude'] = this.businesslatitude;
    data['blockstatus'] = this.blockstatus;
    data['blockedby'] = this.blockedby;
    data['businesstype'] = this.businesstype;
    data['workbusinessname'] = this.workbusinessname;
    data['worktitle'] = this.worktitle;
    data['workemail'] = this.workemail;
    data['website'] = this.website;
    data['about'] = this.about;
    data['meetingdatetime'] = this.meetingdatetime;
    data['webprofileshow'] = this.webprofileshow;
    data['IsVirtualBusiness'] = this.IsVirtualBusiness;
    return data;
  }
}