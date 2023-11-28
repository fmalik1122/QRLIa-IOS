class NotificationsModel{

  String? code;
  String? msg;
  List<Notificationslist> notificationslist = [];

  NotificationsModel({this.code, this.msg, required this.notificationslist});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['notificationslist'] != null) {
      notificationslist = <Notificationslist>[];
      json['notificationslist'].forEach((v) {
        notificationslist.add(new Notificationslist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.notificationslist != null) {
      data['notificationslist'] =
          this.notificationslist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notificationslist {
  String? activitytype;
  String? notificationmessage;
  String? notificationdatetime;
  String? requestid;
  String? frienduserid;
  String? friendname;
  String? friendimage;
  String? requeststatus;
  String? requestdatetime;

  Notificationslist(
      {this.activitytype,
        this.notificationmessage,
        this.notificationdatetime,
        this.requestid,
        this.frienduserid,
        this.friendname,
        this.friendimage,
        this.requeststatus,
        this.requestdatetime});

  Notificationslist.fromJson(Map<String, dynamic> json) {
    activitytype = json['activitytype'];
    notificationmessage = json['notificationmessage'];
    notificationdatetime = json['notificationdatetime'];
    requestid = json['requestid'];
    frienduserid = json['frienduserid'];
    friendname = json['friendname'];
    friendimage = json['friendimage'];
    requeststatus = json['requeststatus'];
    requestdatetime = json['requestdatetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activitytype'] = this.activitytype;
    data['notificationmessage'] = this.notificationmessage;
    data['notificationdatetime'] = this.notificationdatetime;
    data['requestid'] = this.requestid;
    data['frienduserid'] = this.frienduserid;
    data['friendname'] = this.friendname;
    data['friendimage'] = this.friendimage;
    data['requeststatus'] = this.requeststatus;
    data['requestdatetime'] = this.requestdatetime;
    return data;
  }

}