

import 'NetworkListModel.dart';

class UserNetworksListModel {
  String? code;
  String? msg;
  String? userid;
  List<NetworkslistModel> networkslist = [];
  List<NetworkslistModel> usernetworkslist = [];

  UserNetworksListModel({this.code, this.msg, this.userid, required this.networkslist, required this.usernetworkslist});

  UserNetworksListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    userid = json['userid'];
    if (json['networkslist'] != null) {
      networkslist = <NetworkslistModel>[];
      json['networkslist'].forEach((v) {
        networkslist.add(new NetworkslistModel.fromJson(v));
      });
    }

    if (json['usernetworkslist'] != null) {
      usernetworkslist = <NetworkslistModel>[];
      json['usernetworkslist'].forEach((v) {
        usernetworkslist.add(new NetworkslistModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['userid'] = this.userid;
    if (this.networkslist != null) {
      data['networkslist'] = this.networkslist.map((v) => v.toJson()).toList();
    }
    if (this.usernetworkslist != null) {
      data['usernetworkslist'] = this.networkslist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}