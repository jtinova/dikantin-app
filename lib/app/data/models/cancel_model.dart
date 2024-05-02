class ProductCancellation {
  String? status;
  int? kode;

  ProductCancellation({this.status, this.kode});

  ProductCancellation.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    kode = json['kode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['kode'] = kode;
    return data;
  }
}
