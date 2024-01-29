class CartListResponseModel {
  String? status;
  String? message;
  List<CartProductModel>? cartProductLis;

  CartListResponseModel({this.status, this.message, this.cartProductLis});

  CartListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Data'] != null) {
      cartProductLis = <CartProductModel>[];
      json['Data'].forEach((v) {
        cartProductLis!.add(CartProductModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    if (this.cartProductLis != null) {
      data['Data'] = this.cartProductLis!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartProductModel {
  int? cartId;
  String? proId;
  String? proName;
  double? proPrice;
  double? proDiscount;
  double? proSGST;
  int? proQty;
  double? proCGST;
  double? proCourierCharges;
  String? proWeight;
  String? imagePath;

  CartProductModel(
      {this.cartId,
      this.proId,
      this.proName,
      this.proPrice,
      this.proDiscount,
      this.proSGST,
      this.proCGST,
      this.proCourierCharges,
      this.proWeight,
      this.imagePath});

  CartProductModel.fromJson(Map<String, dynamic> json) {
    cartId = json['CartId'];
    proId = json['Pro_Id'];
    proName = json['Pro_Name'];
    proPrice = json['Pro_Price'];
    proDiscount = json['Pro_Discount'];
    proSGST = json['Pro_SGST'];
    proCGST = json['Pro_CGST'];
    proQty = json['Qty'];
    proCourierCharges = json['Pro_Courier_Charges'];
    proWeight = json['Pro_Weight'];
    imagePath = json['ImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CartId'] = cartId;
    data['Pro_Id'] = proId;
    data['Pro_Name'] = proName;
    data['Pro_Price'] = proPrice;
    data['Pro_Discount'] = proDiscount;
    data['Qty'] = proQty;
    data['Pro_SGST'] = proSGST;
    data['Pro_CGST'] = proCGST;
    data['Pro_Courier_Charges'] = proCourierCharges;
    data['Pro_Weight'] = proWeight;
    data['ImagePath'] = imagePath;
    return data;
  }
}
