import '../../cart/model/CartListResponseModel.dart';

class ProductResponseModel {
  String? status;
  String? message;
  List<Product>? productList;

  ProductResponseModel({this.status, this.message, this.productList});

  ProductResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Data'] != null) {
      productList = <Product>[];
      json['Data'].forEach((v) {
        productList!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    if (productList != null) {
      data['Data'] = productList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  String? proId;
  String? proCode;
  String? proName;
  double? proPrice;
  double? proDiscount;
  double? proSGST;
  double? proCGST;
  double? proCourierCharges;
  String? proWeight;
  String? imagePath;
  bool isProductActive = false;
  CartProductModel? model;

  Product(
      {this.proId,
      this.proCode,
      this.proName,
      this.proPrice,
      this.proDiscount,
      this.proSGST,
      this.proCGST,
      this.proCourierCharges,
      this.proWeight,
      this.isProductActive = false,
      this.imagePath});

  Product.fromJson(Map<String, dynamic> json) {
    proId = json['Pro_Id'];
    proCode = json['Pro_Code'];
    proName = json['Pro_Name'];
    proPrice = json['Pro_Price'];
    proDiscount = json['Pro_Discount'];
    proSGST = json['Pro_SGST'];
    proCGST = json['Pro_CGST'];
    proCourierCharges = json['Pro_Courier_Charges'];
    isProductActive = json['Pro_IsActive'].toString().toLowerCase() == "true";
    proWeight = json['Pro_Weight'];
    imagePath = json['ImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Pro_Id'] = proId;
    data['Pro_Code'] = proCode;
    data['Pro_Name'] = proName;
    data['Pro_Price'] = proPrice;
    data['Pro_Discount'] = proDiscount;
    data['Pro_SGST'] = proSGST;
    data['Pro_CGST'] = proCGST;
    data['Pro_IsActive'] = isProductActive;
    data['Pro_Courier_Charges'] = proCourierCharges;
    data['Pro_Weight'] = proWeight;
    data['ImagePath'] = imagePath;
    return data;
  }
}
