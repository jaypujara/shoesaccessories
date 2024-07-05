class OrderHistoryListResponseModel_V2 {
  String? status;
  String? message;
  List<Orders>? orders;

  OrderHistoryListResponseModel_V2({this.status, this.message, this.orders});

  OrderHistoryListResponseModel_V2.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['OH'] != null) {
      orders = <Orders>[];
      json['OH'].forEach((v) {
        orders!.add(new Orders.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.orders != null) {
      data['OH'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Orders {
  List<OrderhistoryDetV2>? orderhistoryDetV2;
  int? orderId;
  int? userId;
  int? addressId;
  String? address;
  double? subTotal;
  double? totalAmount;
  String? orderDate;
  String? expectedDeliveryDate;
  String? status;
  int? statusCode;

  Orders(
      {this.orderhistoryDetV2,
        this.orderId,
        this.userId,
        this.addressId,
        this.address,
        this.subTotal,
        this.totalAmount,
        this.orderDate,
        this.expectedDeliveryDate,
        this.status,
        this.statusCode});

  Orders.fromJson(Map<String, dynamic> json) {
    if (json['Orderhistory_det_v2'] != null) {
      orderhistoryDetV2 = <OrderhistoryDetV2>[];
      json['Orderhistory_det_v2'].forEach((v) {
        orderhistoryDetV2!.add(new OrderhistoryDetV2.fromJson(v));
      });
    }
    orderId = json['OrderId'];
    userId = json['UserId'];
    addressId = json['AddressId'];
    address = json['Address'];
    subTotal = json['SubTotal'];
    totalAmount = json['TotalAmount'];
    orderDate = json['OrderDate'];
    expectedDeliveryDate = json['ExpectedDeliveryDate'];
    status = json['Status'];
    statusCode = json['StatusCode'] != null ? int.parse(json['StatusCode']) : 0;;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderhistoryDetV2 != null) {
      data['Orderhistory_det_v2'] =
          this.orderhistoryDetV2!.map((v) => v.toJson()).toList();
    }
    data['OrderId'] = this.orderId;
    data['UserId'] = this.userId;
    data['AddressId'] = this.addressId;
    data['Address'] = this.address;
    data['SubTotal'] = this.subTotal;
    data['TotalAmount'] = this.totalAmount;
    data['OrderDate'] = this.orderDate;
    data['ExpectedDeliveryDate'] = this.expectedDeliveryDate;
    data['Status'] = this.status;
    data['StatusCode'] = this.statusCode;
    return data;
  }
}

class OrderhistoryDetV2 {
  int? productId;
  String? productCode;
  String? productName;
  double? subTotal;
  double? totalAmount;
  double? qty;
  double? productTotal;
  double? sGST;
  double? cGST;
  String? imagePath;

  OrderhistoryDetV2(
      {this.productId,
        this.productCode,
        this.productName,
        this.subTotal,
        this.totalAmount,
        this.qty,
        this.productTotal,
        this.sGST,
        this.cGST,
        this.imagePath});

  OrderhistoryDetV2.fromJson(Map<String, dynamic> json) {
    productId = json['ProductId'];
    productCode = json['ProductCode'];
    productName = json['ProductName'];
    subTotal = json['SubTotal'];
    totalAmount = json['TotalAmount'];
    qty = json['Qty'];
    productTotal = json['ProductTotal'];
    sGST = json['SGST'];
    cGST = json['CGST'];
    imagePath = json['ImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductId'] = this.productId;
    data['ProductCode'] = this.productCode;
    data['ProductName'] = this.productName;
    data['SubTotal'] = this.subTotal;
    data['TotalAmount'] = this.totalAmount;
    data['Qty'] = this.qty;
    data['ProductTotal'] = this.productTotal;
    data['SGST'] = this.sGST;
    data['CGST'] = this.cGST;
    data['ImagePath'] = this.imagePath;
    return data;
  }
}
