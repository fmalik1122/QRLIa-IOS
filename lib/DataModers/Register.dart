class Register{
  String? code;
  String? msg;
  int? userid;
  int? UserId;
  String? username;
  int? Id;

  Register({required this.code, required this.msg, required this.userid , required this.UserId, required this.username, required this.Id});

  Register.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    userid = json['userid'];
    UserId = json['UserId'];
    username = json['username'];
    Id = json['userid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['userid'] = this.userid;
    data['UserId'] = this.UserId;
    data['username'] = this.username;
    data['userid'] = this.Id;
    return data;
  }
}