class CategoryResponseModel {
  String? status;
  String? message;
  List<Category>? list;

  CategoryResponseModel({this.status, this.message, this.list});

  CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Data'] != null) {
      list = <Category>[];
      json['Data'].forEach((v) {
        list!.add(Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    if (this.list != null) {
      data['Data'] = this.list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String? catId;
  String? catName;
  String? imagePath;

  Category({this.catId, this.catName, this.imagePath});

  Category.fromJson(Map<String, dynamic> json) {
    catId = json['Cat_Id'];
    catName = json['Cat_Name'];
    imagePath = json['ImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Cat_Id'] = catId;
    data['Cat_Name'] = catName;
    data['ImagePath'] = imagePath;
    return data;
  }
}
