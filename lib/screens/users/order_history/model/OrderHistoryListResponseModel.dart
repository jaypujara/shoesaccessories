class OrderHistoryListResponseModel {
  String? status;
  String? message;
  List<OrderModel>? data;

  OrderHistoryListResponseModel({this.status, this.message, this.data});

  OrderHistoryListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Data'] != null) {
      data = <OrderModel>[];
      json['Data'].forEach((v) {
        data!.add(OrderModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderModel {
  int? orderId;
  int? userId;
  int? addressId;
  String? address;
  int? productId;
  String? productName;
  String? productCode;
  double? subTotal;
  double? totalAmount;
  double? qty;
  double? productTotal;
  double? sGST;
  double? cGST;
  String? orderDate;
  String? expectedDeliveryDate;
  String? status;
  int? statusCode;
  String? imagePath;

  OrderModel(
      {this.orderId,
      this.userId,
      this.addressId,
      this.address,
      this.productId,
      this.productName,
      this.productCode,
      this.subTotal,
      this.totalAmount,
      this.qty,
      this.productTotal,
      this.sGST,
      this.cGST,
      this.orderDate,
      this.expectedDeliveryDate,
      this.status,
      this.statusCode,
      this.imagePath});

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['OrderId'];
    userId = json['UserId'];
    addressId = json['AddressId'];
    address = json['Address'];
    productId = json['ProductId'];
    productName = json['ProductName'];
    productCode = json['ProductCode'];
    subTotal = json['SubTotal'];
    totalAmount = json['TotalAmount'];
    qty = json['Qty'];
    productTotal = json['ProductTotal'];
    sGST = json['SGST'];
    cGST = json['CGST'];
    orderDate = json['OrderDate'];
    expectedDeliveryDate = json['ExpectedDeliveryDate'];
    status = json['Status'];
    statusCode = json['StatusCode'] != null ? int.parse(json['StatusCode']) : 0;
    imagePath = json['ImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OrderId'] = orderId;
    data['UserId'] = userId;
    data['AddressId'] = addressId;
    data['Address'] = address;
    data['ProductId'] = productId;
    data['ProductName'] = productName;
    data['ProductCode'] = productCode;
    data['SubTotal'] = subTotal;
    data['TotalAmount'] = totalAmount;
    data['Qty'] = qty;
    data['ProductTotal'] = productTotal;
    data['SGST'] = sGST;
    data['CGST'] = cGST;
    data['OrderDate'] = orderDate;
    data['Status'] = statusCode;
    data['StatusCode'] = statusCode;
    data['ExpectedDeliveryDate'] = expectedDeliveryDate;
    return data;
  }
}
