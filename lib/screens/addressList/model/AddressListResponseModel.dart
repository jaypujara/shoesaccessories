class AddressListResponseModel {
  String? status;
  String? message;
  List<AddressModel>? addressModelList;

  AddressListResponseModel({this.status, this.message, this.addressModelList});

  AddressListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    if (json['Data'] != null) {
      addressModelList = <AddressModel>[];
      json['Data'].forEach((v) {
        addressModelList!.add(AddressModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    if (addressModelList != null) {
      data['Data'] = addressModelList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddressModel {
  int? id;
  int? cusId;
  String? add1;
  String? add2;
  String? add3;
  String? city;
  String? area;
  String? pinCode;
  String? createdBy;

  AddressModel(
      {this.id,
      this.cusId,
      this.add1,
      this.add2,
      this.add3,
      this.city,
      this.area,
      this.pinCode,
      this.createdBy});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    cusId = json['Cus_Id'];
    add1 = json['Add1'];
    add2 = json['Add2'];
    add3 = json['Add3'];
    city = json['City'];
    area = json['Area'];
    pinCode = json['PinCode'];
    createdBy = json['CreatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Cus_Id'] = cusId;
    data['Add1'] = add1;
    data['Add2'] = add2;
    data['Add3'] = add3;
    data['City'] = city;
    data['Area'] = area;
    data['PinCode'] = pinCode;
    data['CreatedBy'] = createdBy;
    return data;
  }
}
