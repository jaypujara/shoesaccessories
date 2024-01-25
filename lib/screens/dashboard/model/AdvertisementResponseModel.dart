class AdvertisementResponseModel {
  String? status;
  String? message;
  List<ImagePathModel>? imagePathList;

  AdvertisementResponseModel({this.status, this.message, this.imagePathList});

  AdvertisementResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Data'] != null) {
      imagePathList = <ImagePathModel>[];
      json['Data'].forEach((v) {
        imagePathList!.add(ImagePathModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    if (imagePathList != null) {
      data['Data'] = imagePathList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImagePathModel {
  String? imagePath;

  ImagePathModel({this.imagePath});

  ImagePathModel.fromJson(Map<String, dynamic> json) {
    imagePath = json['ImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ImagePath'] = imagePath;
    return data;
  }
}
