class OrderStatusUpdateResponseModel {
  String? status;
  String? message;

  OrderStatusUpdateResponseModel({this.status, this.message});

  OrderStatusUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    return data;
  }
}
