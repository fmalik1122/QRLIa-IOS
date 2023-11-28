class BusinessPageModel {
  String? code;
  String? msg;
  String? businessPageName;
  String? businessPageLogo;
  String? businessPageWebsite;
  String? businessPageType;
  String? businessPageDescription;

  BusinessPageModel({this.code,
        this.msg,
        this.businessPageName,
        this.businessPageLogo,
        this.businessPageWebsite,
        this.businessPageType,
        this.businessPageDescription});

  BusinessPageModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    businessPageName = json['BusinessPageName'];
    businessPageLogo = json['BusinessPageLogo'];
    businessPageWebsite = json['BusinessPageWebsite'];
    businessPageType = json['BusinessPageType'];
    businessPageDescription = json['BusinessPageDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['BusinessPageName'] = this.businessPageName;
    data['BusinessPageLogo'] = this.businessPageLogo;
    data['BusinessPageWebsite'] = this.businessPageWebsite;
    data['BusinessPageType'] = this.businessPageType;
    data['BusinessPageDescription'] = this.businessPageDescription;
    return data;
  }
}