class VersionModel {
  String? status;
  String? message;
  Data? data;

  VersionModel({this.status, this.message, this.data});

  VersionModel.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? verNo;
  bool? mandatory;

  Data({this.verNo, this.mandatory});

  Data.fromJson(Map<String, dynamic> json) {
    verNo = json['VerNo'];
    mandatory = json['Mandatory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VerNo'] = verNo;
    data['Mandatory'] = mandatory;
    return data;
  }
}
