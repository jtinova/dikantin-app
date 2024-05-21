class Qr {
  String? data;
  int? code;
  bool? status;

  Qr({this.data, this.code, this.status});

  Qr.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    code = json['code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['data'] = data;
    data['code'] = code;
    data['status'] = status;
    return data;
  }
}
