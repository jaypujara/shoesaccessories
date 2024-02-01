class OrderHistoryListResponseModel {
  String? status;
  String? message;
  List<Order>? orderList;

  OrderHistoryListResponseModel({this.status, this.message, this.orderList});

  OrderHistoryListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Data'] != null) {
      orderList = <Order>[];
      json['Data'].forEach((v) {
        orderList!.add(Order.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    if (orderList != null) {
      data['Data'] = orderList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  int? orderId;
  int? userId;
  int? addressId;
  String? address;
  int? productId;
  String? productName;
  double? subTotal;
  double? totalAmount;
  double? qty;
  String? orderDate;
  String? expectedDeliveryDate;

  Order(
      {this.orderId,
        this.userId,
        this.addressId,
        this.address,
        this.productId,
        this.productName,
        this.subTotal,
        this.totalAmount,
        this.qty,
        this.orderDate,
        this.expectedDeliveryDate});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['OrderId'];
    userId = json['UserId'];
    addressId = json['AddressId'];
    address = json['Address'];
    productId = json['ProductId'];
    productName = json['ProductName'];
    subTotal = json['SubTotal'];
    totalAmount = json['TotalAmount'];
    qty = json['Qty'];
    orderDate = json['OrderDate'];
    expectedDeliveryDate = json['ExpectedDeliveryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OrderId'] = orderId;
    data['UserId'] = userId;
    data['AddressId'] = addressId;
    data['Address'] = address;
    data['ProductId'] = productId;
    data['ProductName'] = productName;
    data['SubTotal'] = subTotal;
    data['TotalAmount'] = totalAmount;
    data['Qty'] = qty;
    data['OrderDate'] = orderDate;
    data['ExpectedDeliveryDate'] = expectedDeliveryDate;
    return data;
  }
}
