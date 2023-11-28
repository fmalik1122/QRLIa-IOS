class CategoriesListModel {
  String? code;
  String? msg;
  List<Categorieslist>? categorieslist;

  CategoriesListModel({this.code, this.msg, this.categorieslist});

  CategoriesListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['categorieslist'] != null) {
      categorieslist = <Categorieslist>[];
      json['categorieslist'].forEach((v) {
        categorieslist!.add(new Categorieslist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.categorieslist != null) {
      data['categorieslist'] =
          this.categorieslist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categorieslist {
  int? categoryId;
  String? categoryName;

  Categorieslist({this.categoryId, this.categoryName});

  Categorieslist.fromJson(Map<String, dynamic> json) {
    categoryId = json['CategoryId'];
    categoryName = json['CategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CategoryId'] = this.categoryId;
    data['CategoryName'] = this.categoryName;
    return data;
  }
}