class CategoryResponseModel {
  String? status;
  String? message;
  List<CategoryModel>? list;

  CategoryResponseModel({this.status, this.message, this.list});

  CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Data'] != null) {
      list = <CategoryModel>[];
      json['Data'].forEach((v) {
        list!.add(CategoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    if (list != null) {
      data['Data'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryModel {
  String? catId;
  String? catName;
  String? imagePath;

  CategoryModel({this.catId, this.catName, this.imagePath});

  CategoryModel.fromJson(Map<String, dynamic> json) {
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
