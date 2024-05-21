class Biayakurir {
  int? data;
  String? message;
  int? code;

  Biayakurir({this.data, this.message, this.code});

  Biayakurir.fromJson(Map<String, dynamic> json) {
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
