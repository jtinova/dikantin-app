class waktuModel {
  String? data;
  String? message;
  int? code;

  waktuModel({this.data, this.message, this.code});

  waktuModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['data'] = data;
    data['message'] = message;
    data['code'] = code;
    return data;
  }
}
