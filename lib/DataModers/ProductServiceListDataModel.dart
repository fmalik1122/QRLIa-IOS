class ProductServiceListDataModel {
  String? code;
  String? msg;
  List<Productslist>? productslist;

  ProductServiceListDataModel({this.code, this.msg, this.productslist});

  ProductServiceListDataModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['productslist'] != null) {
      productslist = <Productslist>[];
      json['productslist'].forEach((v) {
        productslist!.add(new Productslist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.productslist != null) {
      data['productslist'] = this.productslist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Productslist {
  int? id;
  String? type;
  String? category;
  String? name;
  String? description;
  int? price;
  int? averageRating;
  String? fileType;
  String? image;
  String? file;
  String? entryDateTime;

  Productslist(
      {this.id,
        this.type,
        this.category,
        this.name,
        this.description,
        this.price,
        this.averageRating,
        this.fileType,
        this.image,
        this.file,
        this.entryDateTime});

  Productslist.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    type = json['Type'];
    category = json['Category'];
    name = json['Name'];
    description = json['Description'];
    price = json['Price'];
    averageRating = json['AverageRating'];
    fileType = json['FileType'];
    image = json['Image'];
    file = json['File'];
    entryDateTime = json['EntryDateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Type'] = this.type;
    data['Category'] = this.category;
    data['Name'] = this.name;
    data['Description'] = this.description;
    data['Price'] = this.price;
    data['AverageRating'] = this.averageRating;
    data['FileType'] = this.fileType;
    data['Image'] = this.image;
    data['File'] = this.file;
    data['EntryDateTime'] = this.entryDateTime;
    return data;
  }
}
