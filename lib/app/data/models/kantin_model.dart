class Kantin {
  List<DataKantin>? data;
  int? code;
  bool? status;

  Kantin({this.data, this.code, this.status});

  Kantin.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DataKantin>[];
      json['data'].forEach((v) {
        data!.add(DataKantin.fromJson(v));
      });
    }
    code = json['code'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['code'] = code;
    data['status'] = status;
    return data;
  }
}

class DataKantin {
  int? idKantin;
  String? nama;

  DataKantin({this.idKantin, this.nama});

  DataKantin.fromJson(Map<String, dynamic> json) {
    idKantin = json['id_kantin'];
    nama = json['nama'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id_kantin'] = idKantin;
    data['nama'] = nama;
    return data;
  }
}
