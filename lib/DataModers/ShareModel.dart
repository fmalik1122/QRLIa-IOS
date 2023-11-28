class ShareModel{
  String? code;
  String? msg;
  String? RequestId;
  String? ConnectionId;
  String? FriendId;
  String? usertype;

  ShareModel({this.code, this.msg, this.RequestId, this.ConnectionId, this.FriendId, this.usertype});

  ShareModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    RequestId = json['RequestId'];
    ConnectionId = json['ConnectionId'];
    FriendId = json['FriendId'];
    usertype = json['usertype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['RequestId'] = this.RequestId;
    data['ConnectionId'] = this.ConnectionId;
    data['FriendId'] = this.FriendId;
    data['usertype'] = this.usertype;
    return data;
  }
}