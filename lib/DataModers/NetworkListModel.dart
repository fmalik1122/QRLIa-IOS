class NetworkslistModel {
  int? networkid;
  String? networkname;
  String? networkicon;
  String? networkvalue;
  String? networktype;
  String? networkformat;
  String? networkurlforhandles;

  NetworkslistModel({this.networkid, this.networkname, this.networkicon, this.networkvalue, this.networktype, this.networkformat, this.networkurlforhandles});

  NetworkslistModel.fromJson(Map<String, dynamic> json) {
    networkid = json['networkid'];
    networkname = json['networkname'];
    networkicon = json['networkicon'];
    networkvalue = json['networkvalue'];
    networktype = json['networktype'];
    networkformat = json['networkformat'];
    networkurlforhandles = json['networkurlforhandles'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['networkid'] = this.networkid;
    data['networkname'] = this.networkname;
    data['networkicon'] = this.networkicon;
    data['networkvalue'] = this.networkvalue;
    data['networktype'] = this.networktype;
    data['networkformat'] = this.networkformat;
    data['networkurlforhandles'] = this.networkurlforhandles;
    return data;
  }
}