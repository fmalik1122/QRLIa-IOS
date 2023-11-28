class GroupListModel {
  String? code;
  String? msg;
  List<Grouplist>? grouplist;

  GroupListModel({this.code, this.msg, this.grouplist});

  GroupListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['grouplist'] != null) {
      grouplist = <Grouplist>[];
      json['grouplist'].forEach((v) {
        grouplist!.add(new Grouplist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.grouplist != null) {
      data['grouplist'] = this.grouplist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Grouplist {
  int? memberUserId;
  String? memberName;
  String? memberImage;

  Grouplist({this.memberUserId, this.memberName, this.memberImage});

  Grouplist.fromJson(Map<String, dynamic> json) {
    memberUserId = json['MemberUserId'];
    memberName = json['MemberName'];
    memberImage = json['MemberImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MemberUserId'] = this.memberUserId;
    data['MemberName'] = this.memberName;
    data['MemberImage'] = this.memberImage;
    return data;
  }
}
